// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./VotingWithRewards.sol";

contract VotingContract {
    mapping(address => uint256) public shares;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => VotingRecord[]) public votingHistory;
    mapping(uint256 => ProposalOutcome) public proposalOutcomes;
    uint256 public proposalCount;
    uint256 public totalShares;

    enum QuorumType {SimpleMajority, TwoThirds, ThreeQuarters, Unanimous}

    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
        uint256 votingEndTime;
        uint256 totalVotesCast;
        QuorumType quorumType;
    }

    struct VotingRecord {
        uint256 proposalId;
        bool votedFor;
        uint256 voteWeight;
    }

    struct ProposalOutcome {
        bool passed;      
        uint256 votesFor;   
        uint256 votesAgainst;
    }

    bool public isVotingPeriodActive; 
    uint256 public votingEndTime;

    GovernanceToken public governanceToken;

    event ProposalCreated(uint256 proposalId, string description, uint256 votingEndTime);
    event SharesUpdated(address voter, uint256 newShares);
    event VoteCast(uint256 proposalId, address voter, uint256 weight, bool voteFor);
    event RewardIssued(address voter, uint256 rewardAmount);

    constructor(address _tokenAddress) {
        governanceToken = GovernanceToken(_tokenAddress); 
    }
    function registerVoter(address voter, uint256 shareCount) public {
        require(!isVotingPeriodActive, "Hey its an active voting period, you cannot vote now." );
        shares[voter] = shareCount;
        totalShares += shareCount;
    }

    function createProposal(string memory description, uint256 durationInMinutes, QuorumType quorumType) public {
        require(
            shares[msg.sender] * 100 / totalShares >= 5,
            "Sorry, you need to have over 5% to create a proposal"
        );

        proposals[proposalCount] = Proposal({
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            active: true,
            votingEndTime: block.timestamp + durationInMinutes * 1 minutes,
            totalVotesCast: 0,
            quorumType: quorumType
        });

        isVotingPeriodActive = true;
        votingEndTime = block.timestamp + durationInMinutes * 1 minutes;
        emit ProposalCreated(proposalCount, description, votingEndTime);

        proposalCount++;
    }

    function vote(uint256 proposalId, bool voteFor) public {
        require(shares[msg.sender] > 0, "No voting power.");
        require(proposals[proposalId].active, "Proposal inactive.");
        require(proposals[proposalId].votingEndTime >= block.timestamp,
        "Voting period has finished.");

        for (uint256 i = 0; i < votingHistory[msg.sender].length; i++) {
            require(votingHistory[msg.sender][i].proposalId != proposalId, "You already voted on this proposal.");
        }
        uint256 voteWeight = (shares[msg.sender] * 10000) / totalShares;
        
        if (voteFor) {
            proposals[proposalId].votesFor += voteWeight;
        } else {
            proposals[proposalId].votesAgainst += voteWeight;
        }

        proposals[proposalId].totalVotesCast += voteWeight;

        votingHistory[msg.sender].push(VotingRecord({
            proposalId: proposalId,
            votedFor: voteFor,
            voteWeight: voteWeight
        }));


        uint256 rewardAmount = calculateReward(voteWeight);
        require(governanceToken.balanceOf(msg.sender) == 0, "Rewards already claimed.");
        governanceToken.mint(msg.sender, rewardAmount);

        emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);

        if (hasMetQuorum(proposalId)) {
            endVoting(proposalId);
        }
    }

    function calculateReward(uint256 voteWeight) internal pure returns (uint256) {
        return voteWeight / 100;
    }

    function endVoting(uint256 proposalId) public {
        require(proposals[proposalId].active, "Proposal already closed.");
        require(proposals[proposalId].votingEndTime < block.timestamp, "Voting period still going on");
        proposals[proposalId].active = false;
        bool activeProposals = false;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (proposals[i].active) {
                activeProposals = true;
                break;
            }
        }

        bool passed = proposals[proposalId].votesFor > proposals[proposalId].votesAgainst;

        proposalOutcomes[proposalId] = ProposalOutcome({
            passed: passed,
            votesFor: proposals[proposalId].votesFor,
            votesAgainst: proposals[proposalId].votesAgainst
        });

        if (block.timestamp > proposals[proposalId].votingEndTime && !hasMetQuorum(proposalId)) {
            proposals[proposalId].active = false;
            proposalOutcomes[proposalId] = ProposalOutcome(false, proposals[proposalId].votesFor, proposals[proposalId].votesAgainst);
        }

        isVotingPeriodActive = activeProposals;
    }

    function updateShares(address voter, uint256 newShares) public {
        require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }

    function getVotingProgress(uint256 proposalId) public view returns (uint256 progress, uint256 requiredQuorum) {
        Proposal memory proposal = proposals[proposalId];
        uint256 totalVotes = proposal.totalVotesCast;
        uint256 progressPercentage = (totalVotes * 100) / totalShares;
        if (proposal.quorumType == QuorumType.SimpleMajority) {
            requiredQuorum = totalShares / 2;
        } else if (proposal.quorumType == QuorumType.TwoThirds) {
            requiredQuorum = (totalShares * 2) / 3;
        } else if (proposal.quorumType == QuorumType.ThreeQuarters) {
            requiredQuorum = (totalShares * 3) / 4;
        } else if (proposal.quorumType == QuorumType.Unanimous) {
            requiredQuorum = totalShares;
        }
        return (progressPercentage, requiredQuorum);
    }

    function hasMetQuorum(uint256 proposalId) public view returns (bool) {
        Proposal storage proposal = proposals[proposalId];
        uint256 quorumThreshold;

        if (proposal.quorumType == QuorumType.SimpleMajority) {
            quorumThreshold = totalShares / 2;
        } else if (proposal.quorumType == QuorumType.TwoThirds) {
            quorumThreshold = (totalShares * 2) / 3; 
        } else if (proposal.quorumType == QuorumType.ThreeQuarters) {
            quorumThreshold = (totalShares * 3) / 4;
        } else if (proposal.quorumType == QuorumType.Unanimous) {
            quorumThreshold = totalShares;
        }

        return proposal.votesFor >= quorumThreshold;
    }

    function getProposalOutcome(uint256 proposalId) public view returns (ProposalOutcome memory) {
        return proposalOutcomes[proposalId];
    }

    function getProposalsCount() public view returns (uint256) {
        return proposalCount;
    }
}
// contract VotingContract {
//     mapping(address => uint256) public shares;
//     mapping(uint256 => Proposal) public proposals;
//     uint256 public proposalCount;

//     struct Proposal {
//         string description;
//         uint256 votesFor;
//         uint256 votesAgainst;
//         bool active;
//     }

//     function registerVoter(address voter, uint256 shareCount) public {
//         shares[voter] = shareCount;
//     }

//     function createProposal(string memory description) public {
//         proposals[proposalCount] = Proposal({
//             description: description,
//             votesFor: 0,
//             votesAgainst: 0,
//             active: true
//         });
//         proposalCount++;
//     }

//     function vote(uint256 proposalId, bool voteFor) public {
//         require(shares[msg.sender] > 0, "No voting power.");
//         require(proposals[proposalId].active, "Proposal inactive.");
        
//         if (voteFor) {
//             proposals[proposalId].votesFor += shares[msg.sender];
//         } else {
//             proposals[proposalId].votesAgainst += shares[msg.sender];
//         }
//     }
// }

// will work on the commented part

