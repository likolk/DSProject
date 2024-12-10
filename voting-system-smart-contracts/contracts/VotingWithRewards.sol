// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// // this file basically is helpful feature 8 from ReadME.md

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceToken is ERC20, Ownable {
    constructor() ERC20("Governance Token", "GT") Ownable(msg.sender) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

