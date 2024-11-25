// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// this file basically is helpful for the following feature:
// Shareholder Rewards for Voting: Reward shareholders with tokens for participating in votes (e.g., governance tokens or reputation points).(we will need to issue rewards (e.g., governance tokens or reputation points)
// i created this new file in order to have the token contract that shall issue rewards to
// shareholders. 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GovernanceToken is ERC20 {
    constructor() ERC20("Governance Token", "GT) {}
    
    // funciton used to issue tokens to shareholders.
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}


// T.B.D:: This does not work currently as we first need to deploy the GovernanceToken 
// contract to the Ethereum network. After deploying the token, 
// we will pass the deployed token contract address to the VotingContract constructor. 
// This will link the token and voting contracts. Once deployed, voters can vote, and 
// they will receive governance tokens as rewards.
