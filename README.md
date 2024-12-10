# Distributed Systems Dapp Project

Project Objective:
Develop a **Decentralized Voting System** where the voting power of each participant is proportional to the number of shares they hold in a company or organization. This approach is suitable for shareholder meetings or governance decisions in decentralized organizations.

## Features:

✔️ 1. Weighted Voting:
     Each shareholder’s vote is assigned a weight based on the percentage of shares they hold relative to the total shares issued.
     Example: A person with 10% of shares has 10% of the total voting power and his vote will count as 10% of the total votes.

✔️ 2. Share-Based Registration:
     Shareholders register using their Ethereum address, and their voting power is calculated based on their shares. 
     Integrate a smart contract to tokenize shares or link the system with an existing tokenized share registry.
     We have a 1-to-1 mapping of shares and tokens, meaning 100 available shares are mapped to 100 tokens respectively.

✔️ 3. Flexible Decision Thresholds:
     Support for different quorum requirements (4 types of quorum: 50%, 67%, 75%, 100%) based on the vote type.

✔️ 4. Time-Locked Shares:
     Prevent share transfers from affecting voting power during an active voting period.

✔️ 5. Allow shareholders with a minimum percentage of shares (e.g., 50%) to create proposals for voting. This ensures inclusivity while preventing spam proposals from minor shareholders. In our case, to create a proposal you need to be an admin (look at point 9) and to be an admin you need at least 50% of shares/tokens - thus we have only 1 admin who manages the voting altogether.

✔️ 6. Voting History Dashboard
	Provide a simple dashboard showing:
	A list of past proposals with their outcomes.
	(Each shareholder's voting activity (optional))

✔️ 7. Real-Time Progress: Show real-time progress of voting.

✔️ 8. Shareholder Rewards for Voting
Reward shareholders with tokens for participating in votes (e.g., governance tokens or reputation points).

✔️ 9. Implement roles for managing proposals and elections:
     Admins: Can manage voting events.
     Non-Admins: Can view detailed reports but cannot modify anything.

Not Implemented 😔: 

❌ 10. Transparency with Anonymity:
     Display aggregated voting results while maintaining the privacy of individual voters



## How to run the project

To run the project, we will need 3 terminals: one for starting the backend, one for the frontend , one for starting a local Ethereum network node designed for development and Remix IDE to compile and deploy the contracts.

For the backend: cd voting-system-backend -> npm run dev

For the frontend: cd voting-system-frontend -> npm run serve

For the local ETH network: cd voting-system-smart-contracts -> npx hardhat node

For compiling and deploying the contracts, we used Remix IDE (look section below)

## Using REMIX IDE to compile and deploy the contracts
As mentioned previously, we use Remix IDE in order to compile and deploy the contracts. Specifically we will be using 2 files for this, test.sol and smartContract.sol.
In particular, we load those 2 files in Remix, and start off with compiling test.sol using 0.8.26 Solidity version. Upon successful compilation, we make sure to deploy it. We do this by first of all setting up Metamask, adding a localhost network by choosing a network name, the URL (http://127.0.0.1:8545/), the Chain ID (31337) and ETH as currency sumbol. Then we proceed by adding at least an account in our metamask. For this we will be using local hardhat network which provides us with 20 accounts (Addresses and PKs). We simply select some accounts and add them in the Metamask localhost network. Then we proceed in the Remix IDE by selecting the "Injected Provider - Metamask" environment, set 100 ETH as deployment transaction cost of the test contract, and deploy it. Upon successful deployment, we compile the smartContract.sol file, and try to deploy it by setting 1000 ETH as deployment transaction cost. The addresses we will pass will be the addresses of the admins in our metamask configuration, and the tokenaddress will be the deployment address of the test contract. We deploy and upon deployment is successful, we see that we are presented with all the method our smartContract.sol file has in order to interact with the smart contract (i.e. createProposal, addAdmin, etc). Make sure you send some ETH for the transactions that are payable (the transactions that require sending some ETHs for it to be successful).




Pro Tip: Make sure you do npm install in every separate directory to install the required dependencies.