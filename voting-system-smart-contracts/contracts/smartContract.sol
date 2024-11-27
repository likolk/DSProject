// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

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

