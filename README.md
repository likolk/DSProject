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


## FLow to create the project

Initialize a New Node.js Project => npm init -y
This will create a package.json file in your project folder if it doesn't already exist.

Install Hardhat: To initialize a Hardhat project, you need to install Hardhat as a dependency in your project => npm install --save-dev hardhat

Initialize Hardhat Project: After installing Hardhat, run the following command to initialize a new Hardhat project => npx hardhat
After choosing "Create a basic sample project," Hardhat will automatically generate the following:

hardhat.config.js: This is the configuration file.
A contracts/ folder.
A sample test file in test/ folder.

Install Hardhat Toolbox (if necessary): If you didn't select the option to install the Hardhat toolbox during initialization, you can manually install it by running => npm install --save-dev @nomicfoundation/hardhat-toolbox

