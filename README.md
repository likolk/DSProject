# DSProject
DApp Project for Distributed Systems

## Using Hardhat in the project:

The `deploy.js` script uses Hardhat's ethers library to compile and deploy the Voting contract.  
The network configuration in `hardhat.config.js` connects Hardhat to Ganache (localhost at port 7545).  
When we run `npx hardhat run scripts/deploy.js --network localhost`, Hardhat uses Ganache as the blockchain where the contract is deployed.

## Ganache in Project:

It provides 10 pre-funded accounts that act as wallets for testing transactions and contract interactions.  
The deployer account we are using (`ethers.getSigners()[0]`) is one of these accounts from Ganache.  
The deployed contract is stored in Ganache's blockchain, which can be accessed via its RPC URL (http://127.0.0.1:7545).

## For MetaMask:

We connect MetaMask to the Ganache network by adding Ganache’s RPC URL (`http://127.0.0.1:7545`) in MetaMask in the section for adding a custom network.  
Import one of Ganache's private keys into MetaMask. Dynamically, if the ether balance is reduced in the Ganache interface, it will be reflected in MetaMask too.  
Through MetaMask, users can vote by sending transactions to the deployed contract on the Ganache blockchain. We will see that later.
