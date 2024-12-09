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
Role-Based Admin Controls

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

For compiling and deploying the contracts, we used Remix IDE.

Pro Tip: Make sure you do npm install in every separate directory to install the required dependencies.