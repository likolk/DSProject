// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingContract {
    mapping(address => uint256) public shares;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
        uint256 votingEndTime
    }

    // is voting active (used to Prevent share transfers from affecting voting power during an active voting period. )
    bool public isVotingPeriodActive; 
    // when voting ends
    uint256 public votingEndTime;

    event ProposalCreated(uint256 proposalId, string description, uint256 votingEndTime);
    event SharesUpdated(address voter, uint256 newShares);

    // register voter along their shares
    function registerVoter(address voter, uint256 shareCount) public {
        require(!isVotingPeriodActive, "Hey its an active voting period, you cannot vote now." );
        shares[voter] = shareCount;
    }

    function createProposal(string memory description, uint256 durationInMinutes) public {
        uint256 totalShares = 0;
        for (uint256 i = 0; i < proposalCount; i++) {
            totalShares += shares[msg.sender];
        }

        require(
            shares[msg.sender] * 100 / totalShares >= 5,
            "Sorry you need to have over 5% to create a proposal"
        )

        proposals[proposalCount] = Proposal({
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            active: true,
            votingEndTime: block.timestamp + durationInMinutes * 1 minutes
        });

        isVotingPeriodActive = true;
        votingEndTime = block.timestamp + durationInMinutes * 1 minutes;
        emit ProposalCreated(proposalCount, description, votingEndTime);

        proposalCount++;
    }

    function vote(uint256 proposalId, bool voteFor) public {
        require(shares[msg.sender] > 0, "No voting power.");
        require(proposals[proposalId].active, "Proposal inactive.");
        require(proposals[proposalId].votingEndTime >= block.timestamp.
        "Voting period has finished.")
        
        if (voteFor) {
            proposals[proposalId].votesFor += shares[msg.sender];
        } else {
            proposals[proposalId].votesAgainst += shares[msg.sender];
        }
    }

    // end a voting period
    function endVoting(uint256 proposalId) public {
        require(proposals[proposalId].active, "Proposal already closed.");
        require(proposals[proposalId].votingEndTime < block.timestamp, "Voting period still going on");
        proposals[proposalId].active = false;
        bool activeProposals = false;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (proposal[i].active) {
                activeProposals = true;
                break;
            }
        }
        isVotingPeriodActive = activeProposals;
    }

    function updateShares(address voter, uint256 newShares) public {
        require(!isVotingPeriodActive, "cannot update shares during ongoing votong period")
        shares[voter] = newShares;
        emit SharesUpdated(voter, newShares);
    }
}
