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
        active: true
    }));

    uint256 proposalId = proposals.length - 1;
    proposalCount++;

    emit ProposalCreated(proposalId, title, description, durationInMinutes, quorumType, endTime, msg.sender);
}

    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }

    // function get proposals, based on this 
    /*
    async fetchProposals() {
    console.log("Fetching proposals in VotingComponent");
    const web3 = new Web3(window.ethereum);
    try {
        console.log("Step 1")
        const contract = await this.getVotingContract(web3);
        console.log("Step 2")
        const proposals = await contract.methods.getProposals().call();
        // JavaScript code

        // You can now access each proposal's attributes:
        proposals.forEach(proposal => {
        console.log(proposal.title);
        console.log(proposal.description);
        console.log(proposal.votesFor);
        console.log(proposal.votesAgainst);
        console.log(proposal.active);
        console.log(proposal.votingEndTime);
        console.log(proposal.quorumType);
        });


        console.log("Step 3")
        console.log("Fetched proposals:", proposals);

        const { ids, titles, descriptions, votesForArray, votesAgainstArray, actives } = proposals;
        console.log("Step 4")
        const proposalsList = ids.map((id, index) => ({
            id: id,
            title: titles[index],
            description: descriptions[index],
            votesFor: votesForArray[index],
            votesAgainst: votesAgainstArray[index],
            active: actives[index],
        }));
        console.log("Step 5")
        console.log('Proposals:', proposalsList);
        this.proposals = proposalsList;
    } catch (error) {
        console.error('Error fetching proposals:', error);
    }
},*/

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


    // function vote(uint256 proposalId, bool voteFor) public {
    //     // require(shares[msg.sender] > 0, "No voting power.");
    //     // require(proposals[proposalId].active, "Proposal inactive.");
    //     // require(proposals[proposalId].votingEndTime >= block.timestamp,
    //     // "Voting period has finished.");

    //     // for (uint256 i = 0; i < votingHistory[msg.sender].length; i++) {
    //     //     require(votingHistory[msg.sender][i].proposalId != proposalId, "You already voted on this proposal.");
    //     // }
    //     uint256 voteWeight = (shares[msg.sender] * 10000) / totalShares;

    //     if (voteFor) {
    //         proposals[proposalId].votesFor += voteWeight;
    //     } else {
    //         proposals[proposalId].votesAgainst += voteWeight;
    //     }

    //     proposals[proposalId].totalVotesCast += voteWeight;

    //     votingHistory[msg.sender].push(
    //         VotingRecord({
    //             proposalId: proposalId,
    //             votedFor: voteFor,
    //             voteWeight: voteWeight
    //         })
    //     );

    //     uint256 rewardAmount = calculateReward(voteWeight);
    //     // require(governanceToken.balanceOf(msg.sender) == 0, "Rewards already claimed.");
    //     governanceToken.mint(msg.sender, rewardAmount);

    //     emit VoteCast(proposalId, msg.sender, voteWeight, voteFor);

    //     if (hasMetQuorum(proposalId)) {
    //         endVoting(proposalId);
    //     }
    // }

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
}