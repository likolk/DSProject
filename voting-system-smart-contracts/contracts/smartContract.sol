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
    uint256 public totalShares;
    mapping(address => bool) public voted;




    enum QuorumType {
        SimpleMajority,
        TwoThirds,
        ThreeQuarters,
        Unanimous
    }


struct Proposal {
    string title;
    string description;
    uint256 durationInMinutes;
    uint8 quorumType;
    uint256 endTime;
    address proposer;
    bool active;
    uint256 votesFor;  
    uint256 votesAgainst;
}


    Proposal[] public proposals;
    uint256 public proposalCount;

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
        string title,
        string description,
        uint256 durationInMinutes,
        uint8 quorumType,
        uint256 endTime,
        address proposer
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

function createProposal(
    string memory title,
    string memory description,
    uint256 durationInMinutes,
    uint8 quorumType
) public payable {
    require(msg.value == 1 ether, "Must send 1 ETH to create a proposal");

    uint256 endTime = block.timestamp + (durationInMinutes * 1 minutes);

    proposals.push(Proposal({
        title: title,
        description: description,
        durationInMinutes: durationInMinutes,
        quorumType: quorumType,
        endTime: endTime,
        proposer: msg.sender,
        active: true,
        votesFor: 0,
        votesAgainst: 0

    }));

    uint256 proposalId = proposals.length - 1;
    proposalCount++;

    emit ProposalCreated(proposalId, title, description, durationInMinutes, quorumType, endTime, msg.sender);
}

    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

   function getProposals() public view returns (Proposal[] memory) {
    return proposals;
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

    function calculateReward(
        uint256 voteWeight
    ) internal pure returns (uint256) {
        return voteWeight / 100;
    }

    function updateShares(address voter, uint256 newShares) public {
        // require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }


    function getProposalOutcome(
        uint256 proposalId
    ) public view returns (ProposalOutcome memory) {
        return proposalOutcomes[proposalId];
    }

    function getProposalsCount() public view returns (uint256) {
        return proposalCount;
    }

    function castVote(uint256 proposalId, bool voteFor) public {
        require(!voted[msg.sender], "You have already voted");
        require(proposals[proposalId].active, "Proposal is not active");

        uint256 voteWeight = shares[msg.sender];
        require(voteWeight > 0, "You must hold shares to vote");

        if (voteFor) {
            proposals[proposalId].votesFor += voteWeight;
        } else {
            proposals[proposalId].votesAgainst += voteWeight;
        }

        // Record the vote
        votingHistory[msg.sender].push(VotingRecord({
            proposalId: proposalId,
            votedFor: voteFor,
            voteWeight: voteWeight
        }));

        voted[msg.sender] = true;  // Mark the user as having voted

        emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);
    }

    event ProposalDeleted(uint256 proposalId);

    function deleteProposal(uint256 proposalId) public {
        // require(proposalId < proposals.length, "Invalid proposal ID");
        proposals[proposalId].active = false;
        emit ProposalDeleted(proposalId);
    }

}