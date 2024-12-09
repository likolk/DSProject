// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./VotingWithRewards.sol";

contract VotingContract {
mapping(address => uint256) public shares; 
    mapping(address => uint256) public tokens; 
    mapping(address => VotingRecord[]) public votingHistory;
    mapping(uint256 => ProposalOutcome) public proposalOutcomes;
    mapping(address => bool) public admins;
    mapping(uint256 => mapping(address => bool)) public voted;
    address[] public adminAddresses;


    enum QuorumType {
        SimpleMajority,
        TwoThirds,
        ThreeQuarters,
        Unanimous
    }


struct Proposal {
    string title;
    string description;
    uint8 durationInMinutes;
    uint8 quorumType;
    uint256 endTime;
    address proposer;
    bool active;
    uint256 votesFor;  
    uint256 votesAgainst;
}


    Proposal[] public proposals;
    uint8 public proposalCount;

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

    // GovernanceToken public governanceToken;

    event ProposalCreated(
        uint256 proposalId,
        string title,
        string description,
        uint8 durationInMinutes,
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
    constructor(address[] memory initialAdmins, address _tokenAddress) payable {
            // governanceToken = GovernanceToken(_tokenAddress);
            require(msg.value >= 1 ether, "You must send at least 1 ETH to deploy the contract");
            require(initialAdmins.length > 0, "Initial admins required");
            require(_tokenAddress != address(0), "Invalid token address");


            for (uint i = 0; i < initialAdmins.length; i++) {
                admins[initialAdmins[i]] = true;
                adminAddresses.push(initialAdmins[i]); 
            }
        }

        modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action");
        _;
    }

function createProposal(
    string memory title,
    string memory description,
    uint8 durationInMinutes,
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
    proposalCount++;

    emit ProposalCreated(proposalCount - 1, title, description, durationInMinutes, quorumType, endTime, msg.sender);
}
    // fallback function to handle unexpected calls or Ether transfers with data
    receive() external payable {}

    // fallback function to handle unexpected calls or Ether transfers with data
    fallback() external payable {
    }

    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

   function getProposals() public view returns (Proposal[] memory) {
    return proposals;
}

    function removeAdmin(address admin) public onlyAdmin {
        admins[admin] = false;
    }

    function isAdmin(address user) public view returns (bool) {
        return admins[user];
    }

    function registerShareholder(address account, uint256 _shares) external {
        shares[account] = _shares;
        tokens[account] = _shares; 
    }

    function getTokens(address account) external view returns (uint256) {
        return tokens[account];
    }

    function updateShares(address voter, uint256 newShares) public {
        require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }


    function getProposalOutcome(uint256 proposalId) public view returns (ProposalOutcome memory) {
        return proposalOutcomes[proposalId];
    }

    function getProposalsCount() public view returns (uint8) {
        return proposalCount;
    }

    function castVote(uint256 proposalId, bool voteFor) public {
        // require(!voted[msg.sender], "You have already voted");
        require(!voted[proposalId][msg.sender], "You have already voted");
        require(proposals[proposalId].active, "Proposal is not active");

        uint256 voteWeight = shares[msg.sender];
        require(voteWeight > 0, "You must hold shares to vote");

        if (voteFor) {
            proposals[proposalId].votesFor += voteWeight;
        } else {
            proposals[proposalId].votesAgainst += voteWeight;
        }

        votingHistory[msg.sender].push(VotingRecord({
            proposalId: proposalId,
            votedFor: voteFor,
            voteWeight: voteWeight
        }));

        // voted[msg.sender] = true;  
        voted[proposalId][msg.sender] = true;

        emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);

        issueReward(msg.sender, voteWeight);


        if (checkQuorum(proposalId)) {
            Proposal storage proposal = proposals[proposalId];
            proposal.active = false;
            bool passed = proposal.votesFor > proposal.votesAgainst;
            proposalOutcomes[proposalId] = ProposalOutcome({
                passed: passed,
                votesFor: proposal.votesFor,
                votesAgainst: proposal.votesAgainst
            });
        }
    }

event ProposalDeleted(uint256 indexed proposalId);

    function deleteProposal(uint8 proposalId) external onlyAdmin {
        require(proposalId < proposals.length, "Invalid proposal ID");
        require(proposals[proposalId].active, "Proposal is not active");
        emit ProposalDeleted(proposalId);
        proposals[proposalId].active = false;
    }

    function getAdmins() public view returns (address[] memory) {
        return adminAddresses;
    }

    // check if proposal is active
    function isProposalActive(uint256 proposalId) public view returns (bool) {
        return proposals[proposalId].active;
    }   
    // this is for real time voting
    function getProposalVotes(uint256 proposalId) public view returns (uint256 votesFor, uint256 votesAgainst, bool active) {
        require(proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        return (proposal.votesFor, proposal.votesAgainst, proposal.active);
    }

    // set voting period to active and non active
    function setVotingPeriod(bool active, uint256 durationInMinutes) public onlyAdmin {
        isVotingPeriodActive = active;
        votingEndTime = block.timestamp + (durationInMinutes * 1 minutes);
    }

    // make sure that when the quorum is met, the proposal is passed
    function checkQuorum(uint256 proposalId) public view returns (bool) {
        Proposal storage proposal = proposals[proposalId];
        uint256 totalVotes = proposal.votesFor + proposal.votesAgainst;
        uint256 quorum;
        if (proposal.quorumType == uint8(QuorumType.SimpleMajority)) {
            quorum = totalVotes / 2;
        } else if (proposal.quorumType == uint8(QuorumType.TwoThirds)) {
            quorum = (totalVotes * 2) / 3;
        } else if (proposal.quorumType == uint8(QuorumType.ThreeQuarters)) {
            quorum = (totalVotes * 3) / 4;
        } else if (proposal.quorumType == uint8(QuorumType.Unanimous)) {
            quorum = totalVotes;
        }
        return proposal.votesFor > quorum;
    }

    function getVotingHistory(address voter) external view returns (VotingRecord[] memory) {
        return votingHistory[voter];
    }

    function calculateReward(uint256 voteWeight) internal pure returns (uint256) {
        return voteWeight / 100;
    }

    function issueReward(address voter, uint256 voteWeight) internal {
        uint256 rewardAmount = calculateReward(voteWeight);
        // GovernanceToken(governanceTokenAddress).mint(voter, rewardAmount);
        emit RewardIssued(voter, rewardAmount);
    }

    // transfer shares from one account to another
    function transferShares(address from, address to, uint256 amount) public {
        require(!isVotingPeriodActive, "cannot update shares during ongoing votong period");
        require(shares[from] >= amount, "Insufficient shares");
        shares[from] -= amount;
        shares[to] += amount;
    }
}