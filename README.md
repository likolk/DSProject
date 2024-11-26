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

4. Transparency with Anonymity:
     Display aggregated voting results while maintaining the privacy of individual voters
.
5. Time-Locked Shares:
     Prevent share transfers from affecting voting power during an active voting period.

6. Allow shareholders with a minimum percentage of shares (e.g., 5%) to create proposals for voting. This ensures inclusivity while preventing spam proposals from minor shareholders.

7. Voting History Dashboard
	Provide a simple dashboard showing:
	A list of past proposals with their outcomes.
	Each shareholder's voting activity (optional).

8. Real-Time Progress: Show real-time progress of voting.
Example: 35% of total shares have voted; 50% required for quorum.

9. Shareholder Rewards for Voting
Reward shareholders with tokens for participating in votes (e.g., governance tokens or reputation points).
Role-Based Admin Controls

10. Implement roles for managing proposals and elections:
     Admins: Can oversee and manage voting events.
     Auditors: Can view detailed reports but cannot modify anything.


------------------

Issues: Compatibility issue between ethers and ganache. (we will use web3 as an alternative to ethers)


TODOs: use web3 to dynamically update address and balances from ganache.
