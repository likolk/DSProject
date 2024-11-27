// SPDX-License-Identifier: MIT

// This is a license identifier. Declares the contract is open-source under the MIT license, meaning anyone can use and modify it.
pragma solidity ^0.8.26;  // solidity compiler version 0.8.0 or higher

contract Voting {  // class voting
    struct Candidate {  // Struct: A custom data type for grouping related data.
        string name;  // The candidate's name.
        uint voteCount;  // Tracks how many votes this candidate has.
    }
// These are state variables. State variables: Store data on the blockchain.
    address public owner; // Stores the address of the contract's creator (owner).  public: Makes it readable from outside the contract.
    mapping(address => bool) public hasVoted;  // Tracks whether an address (a user) has already voted. Key: Voter’s address. Value: true if they’ve voted, false otherwise.
    Candidate[] public candidates; // An array named Candidate that holds all the candidates running for election.  public: Lets us read the list of candidates.

    constructor(string[] memory candidateNames) {  // Constructor: A special function that runs only once (when the contract is deployed).
        owner = msg.sender;  // Sets owner to the deployer’s address (msg.sender).
        //  Loops through the candidateNames array and adds each name to the candidates array with an initial vote count of 0.
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

//  Function that will allow users to vote : Allows users to cast a vote.
    function vote(uint candidateIndex) public {
        require(!hasVoted[msg.sender], "You have already voted.");  // require(!hasVoted[msg.sender], ...): Ensures the voter hasn’t voted before.
        require(candidateIndex < candidates.length, "Invalid candidate.");  // Ensures the selected candidate is valid.

        hasVoted[msg.sender] = true;  // Marks the voter as having voted (hasVoted[msg.sender] = true).
        candidates[candidateIndex].voteCount++;  //  Increments the selected candidate’s vote count (voteCount++).
    }


//  Function: Returns the list of all candidates.
    function getCandidates() public view returns (Candidate[] memory) {  //  view: Indicates this function doesn’t modify the blockchain.
        return candidates;  
    }
}
