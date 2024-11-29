// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./VotingWithRewards.sol";

contract VotingContract {
    mapping(address => uint256) public shares;
    // mapping(uint256 => Proposal) public proposals;
    mapping(address => VotingRecord[]) public votingHistory;
    mapping(uint256 => ProposalOutcome) public proposalOutcomes;
    mapping(address => bool) public admins;
    uint256 public proposalCount;
    uint256 public totalShares;



    enum QuorumType {
        SimpleMajority,
        TwoThirds,
        ThreeQuarters,
        Unanimous
    }


    struct Proposal {
            string title;
            string description;
            uint256 votesFor;
            uint256 votesAgainst;
            bool active;
            uint256 votingEndTime;
            uint256 totalVotesCast;
            QuorumType quorumType;
        }

    Proposal[] public proposals;

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

    event ProposalCreated(
        uint256 proposalId,
        string description,
        uint256 votingEndTime
    );
    event SharesUpdated(address voter, uint256 newShares);
    event VoteCast(
        uint256 proposalId,
        address voter,
        uint256 weight,
        bool voteFor
    );
    event RewardIssued(address voter, uint256 rewardAmount);

    // constructor to initialize admins
    constructor(address[] memory initialAdmins, address _tokenAddress) {
            governanceToken = GovernanceToken(_tokenAddress);

            for (uint i = 0; i < initialAdmins.length; i++) {
                admins[initialAdmins[i]] = true;
            }
        }

        modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action");
        _;
    }

    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

    // Optional: Function to remove an admin dynamically
    function removeAdmin(address admin) public onlyAdmin {
        admins[admin] = false;
    }

    // check if the user is an admin
    function isAdmin(address user) public view returns (bool) {
        return admins[user];
    }


    function registerShareholder(address voter, uint256 shareCount) public {
        require(
            !isVotingPeriodActive,
            "Hey its an active voting period, you cannot vote now."
        );
        shares[voter] = shareCount;
        totalShares += shareCount;
    }

    function createProposal(
        string memory title,
        string memory description,
        uint256 durationInMinutes,
        QuorumType quorumType
    ) public payable onlyAdmin {
        // require(
        //     shares[msg.sender] * 100 / totalShares >= 5,
        //     "Sorry, you need to have over 5% to create a proposal"
        // );
        require(msg.value > 0, "ETH required for creating proposal");
        proposals[proposalCount] = Proposal({
            title: title,
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
        // require(shares[msg.sender] > 0, "No voting power.");
        // require(proposals[proposalId].active, "Proposal inactive.");
        // require(proposals[proposalId].votingEndTime >= block.timestamp,
        // "Voting period has finished.");

        // for (uint256 i = 0; i < votingHistory[msg.sender].length; i++) {
        //     require(votingHistory[msg.sender][i].proposalId != proposalId, "You already voted on this proposal.");
        // }
        uint256 voteWeight = (shares[msg.sender] * 10000) / totalShares;

        if (voteFor) {
            proposals[proposalId].votesFor += voteWeight;
        } else {
            proposals[proposalId].votesAgainst += voteWeight;
        }

        proposals[proposalId].totalVotesCast += voteWeight;

        votingHistory[msg.sender].push(
            VotingRecord({
                proposalId: proposalId,
                votedFor: voteFor,
                voteWeight: voteWeight
            })
        );

        uint256 rewardAmount = calculateReward(voteWeight);
        // require(governanceToken.balanceOf(msg.sender) == 0, "Rewards already claimed.");
        governanceToken.mint(msg.sender, rewardAmount);

        emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);

        if (hasMetQuorum(proposalId)) {
            endVoting(proposalId);
        }
    }

    function calculateReward(
        uint256 voteWeight
    ) internal pure returns (uint256) {
        return voteWeight / 100;
    }

    function endVoting(uint256 proposalId) public {
        // require(proposals[proposalId].active, "Proposal already closed.");
        // require(proposals[proposalId].votingEndTime < block.timestamp, "Voting period still going on");
        proposals[proposalId].active = false;
        bool activeProposals = false;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (proposals[i].active) {
                activeProposals = true;
                break;
            }
        }

        bool passed = proposals[proposalId].votesFor >
            proposals[proposalId].votesAgainst;

        proposalOutcomes[proposalId] = ProposalOutcome({
            passed: passed,
            votesFor: proposals[proposalId].votesFor,
            votesAgainst: proposals[proposalId].votesAgainst
        });

        if (
            block.timestamp > proposals[proposalId].votingEndTime &&
            !hasMetQuorum(proposalId)
        ) {
            proposals[proposalId].active = false;
            proposalOutcomes[proposalId] = ProposalOutcome(
                false,
                proposals[proposalId].votesFor,
                proposals[proposalId].votesAgainst
            );
        }

        isVotingPeriodActive = activeProposals;
    }

    function updateShares(address voter, uint256 newShares) public {
        // require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }

    function getVotingProgress(
        uint256 proposalId
    ) public view returns (uint256 progress, uint256 requiredQuorum) {
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

    function getProposalOutcome(
        uint256 proposalId
    ) public view returns (ProposalOutcome memory) {
        return proposalOutcomes[proposalId];
    }

    function getProposalsCount() public view returns (uint256) {
        return proposalCount;
    }

function getProposals() public view returns (
        uint256[] memory ids,
        string[] memory titles,
        string[] memory descriptions,
        uint256[] memory votesForArray,
        uint256[] memory votesAgainstArray,
        bool[] memory actives,
        uint256[] memory quorum
    ) {
        // proposalCount = proposals.length;

        ids = new uint256[](proposalCount);
        titles = new string[](proposalCount);
        descriptions = new string[](proposalCount);
        votesForArray = new uint256[](proposalCount);
        votesAgainstArray = new uint256[](proposalCount);
        actives = new bool[](proposalCount);
        quorum = new uint256[](proposalCount);

        for (uint256 i = 0; i < proposalCount; i++) {
            Proposal storage proposal = proposals[i];
            ids[i] = i;
            titles[i] = proposal.title;
            descriptions[i] = proposal.description;
            votesForArray[i] = proposal.votesFor;
            votesAgainstArray[i] = proposal.votesAgainst;
            actives[i] = proposal.active;
            quorum[i] = uint256(proposal.quorumType);
        }
    }

    function addProposal(string memory _title, string memory _description) public {
        proposals.push(Proposal({
            title: _title,
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            active: true,
            votingEndTime: block.timestamp + 7 days, 
            totalVotesCast: 0,
            quorumType: QuorumType.SimpleMajority

        }));
    }


    function getTotalSharesVoted(
        uint256 proposalId
    ) public view returns (uint256) {
        uint256 totalSharesVoted = proposals[proposalId].totalVotesCast;
        return totalSharesVoted;
    }

    // getshares function
    function getShares(address voter) public view returns (uint256) {
        return shares[voter];
    }
    function getUserProfile(address voter) public view returns (uint256, VotingRecord[] memory) {
        return (shares[voter], votingHistory[voter]);
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
