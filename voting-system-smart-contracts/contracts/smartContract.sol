// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VotingContract {
    mapping(address => uint256) public shares;
    mapping(uint256 => Proposal) public proposals;
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
        // the field below is used for flexible decision thresholds feature (i.e. general, critical, special)
        QuorumType quorumType;
    }

    // is voting active (used to Prevent share transfers from affecting voting power during an active voting period. )
    bool public isVotingPeriodActive; 
    // when voting ends
    uint256 public votingEndTime;

    ERC20 public governanceToken;

    event ProposalCreated(uint256 proposalId, string description, uint256 votingEndTime);
    event SharesUpdated(address voter, uint256 newShares);
    // mainly usied for logging
    event VoteCast(uint256 proposalId, address voter, uint256 weight, bool voteFor);
    event RewardIssued(address voter, uint256 rewardAmount);

    constructor(address _tokenAddress) {
        governanceToken = GovernanceToken(_tokenAddress);
    }

    // register voter along their shares (2. Share-Based Registration)
    function registerVoter(address voter, uint256 shareCount) public {
        require(!isVotingPeriodActive, "Hey its an active voting period, you cannot vote now." );
        shares[voter] = shareCount;
        totalShares += shareCount;
    }

    function createProposal(string memory description, uint256 durationInMinutes, QuorumType quorumType) public {
        uint256 totalShares = 0;
        for (uint256 i = 0; i < proposalCount; i++) {
            totalShares += shares[msg.sender];
        }

        require(
            shares[msg.sender] * 100 / totalShares >= 5,
            "Sorry you need to have over 5% to create a proposal"
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

        // voting weight calculated basedf on peercentage of shares owned
        uint256 voteWeight = (shares[msg.sender] * 10000) / totalShares;
        
        if (voteFor) {
            proposals[proposalId].votesFor += voteWeight;
        } else {
            proposals[proposalId].votesAgainst += voteWeight;
        }

        proposals[proposalId].totalVotesCast += voteWeight;

        uint256 rewardAmount = calculateReward(voteWeight);
        governanceToken.mint(msg.sender, rewardAmount);

        emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);

        if (hasMetQuorum(proposalId)) {
            endVoting(proposalId);
        }
    }

    function calculateReward(uint256 voteWeight) internal pure returns (uint256) {
        // we make reward be proportional to the weight of the vote the shareholdefr has. lets say 1 percent
        return voteWeight / 100;
    }

    // end a voting period
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
        isVotingPeriodActive = activeProposals;
    }

    function updateShares(address voter, uint256 newShares) public {
        require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }

    // real time voting progress
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
        uint256 totalVotes = proposal.votesFor + proposal.votesAgainst;
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
}
