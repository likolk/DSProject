# DSProject
DApp Project for Distributed Systems

Objective:
Develop a decentralized voting system where the voting power of each participant is proportional to the number of shares they hold in a company or organization. This approach is suitable for shareholder meetings or governance decisions in decentralized organizations.

Features:
1. Weighted Voting:
     Each shareholder’s vote is assigned a weight based on the percentage of shares they hold relative to the total shares issued.
     Example: A person with 10% of shares has 10% of the total voting power and his vote will count as 10% of the total votes.

2. Share-Based Registration:
     Shareholders register using their Ethereum address, and their voting power is calculated based on their shares.
     Optionally, integrate a smart contract to tokenize shares or link the system with an existing tokenized share registry.

3. Flexible Decision Thresholds:
     Support for different quorum requirements (e.g., simple majority, 2/3 majority) based on the vote type.

4. Time-Locked Shares:
     Prevent share transfers from affecting voting power during an active voting period.

5. Allow shareholders with a minimum percentage of shares (e.g., 5%) to create proposals for voting. This ensures inclusivity while preventing spam proposals from minor shareholders.

6. Voting History Dashboard
	Provide a simple dashboard showing:
	A list of past proposals with their outcomes.
	(Each shareholder's voting activity (optional))

7. Real-Time Progress: Show real-time progress of voting.
Example: 35% of total shares have voted; 50% required for quorum.

8. Shareholder Rewards for Voting
Reward shareholders with tokens for participating in votes (e.g., governance tokens or reputation points).
Role-Based Admin Controls

Not Implemented (yet?)

9. Transparency with Anonymity:
     Display aggregated voting results while maintaining the privacy of individual voters

10. Implement roles for managing proposals and elections:
     Admins: Can oversee and manage voting events.
     Auditors: Can view detailed reports but cannot modify anything.


------------------

Issues: Compatibility issue between ethers and ganache. (we will use web3 as an alternative to ethers)


TODOs: use web3 to dynamically update address and balances from ganache.

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

To run:
npx hardhat run scripts/deploy.js --network localhost => to deploy the contract on one of the account of ganache.

npx hardhat run scripts/interact.js --network localhost => to vote