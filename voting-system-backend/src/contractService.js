// // logic to interact with smart contracts
// const { ethers } = require("ethers");
// const fs = require('fs'); 
// const path = require('path');
// require('dotenv').config();

// const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

// const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

// const contractABI = JSON.parse(fs.readFileSync(path.join(__dirname, '../..', 'artifacts', 'contracts', 'smartContract.sol', 'VotingContract.json'))).abi;
// const contractAddress = process.env.CONTRACT_ADDRESS;

// const contract = new ethers.Contract(contractAddress, contractABI, signer);

// async function registerVoter(address, shares) {
//   const tx = await contract.registerVoter(address, shares);
//   await tx.wait();
//   return tx.hash; 
// }

// async function getProposalVotes(proposalId) {
//   const votes = await contract.getProposalVotes(proposalId);
//   return votes;
// }

// async function createProposal(description, durationInMinutes) {
//   const tx = await contract.createProposal(description, durationInMinutes)
//   await tx.wait();
//   // transaction hash returnt for tracking
//   return tx.hash; 
// }

// async function listAllProposals() {
//   const proposalCount = await contract.getProposalVotes();
//   const proposals = []
//   for (let i = 0; i < proposalCount; i ++) {
//     const proposal = await contract.proposals(i);
//     proposals.push({
//       id: i,
//       description: proposal.description,
//       votesFor: proposal.votesFor.toString(),
//       votesAgainst: proposal.votesAgainst.toString(),
//       active: proposal.active,
//     });
//   }
//   return proposals;
// }

// // to be used on the frontend if the user has less than 5% of shares
// async function getUserShares(address) {
//   const shares = await contract.shares(address);
//   return ethers.BigNumber.from(shares).toString();
// }

// async function endVoting(proposalId) {
//   const tx = await contract.endVoting(proposalId);
//   await tx.wait();
//   return tx.hash();
// }

// async function updateShares(address, newShares) {
//   const tx = await contract.updateShares(address, newShares);
//   await tx.wait();
//   return tx.hash();
// }

// async function getTotalShares() {
//   return await contract.totalShares();
// }

// // done after the vote is casted on the blockchain, we can then query the token balances of voters.
// async function getRewardBalance(address) {
//   const balance = await governanceToken.balanceOf(address);
//   return balance;
// }

// async function getVotingProgress(proposalId) {
//   const progress = await contract.methods.getVotingProgress(proposalId).call();
//   // we use .call() as it can be used to getch data from the blockcahin without altering anything.
//   return progress;
// }

// async function checkQuorum(proposalId) {
//   const result = await contract.hasMetQuorum(proposalId);
//   return result;
// }


// module.exports = { 
//   ...require('./contractService'),
//   listAllProposals,
//   createProposal,
//   registerVoter, 
//   getProposalVotes ,
//   endVoting,
//   updateShares,
//   getUserShares,
//   getTotalShares,
//   getRewardBalance,
//   getVotingProgress,
//   checkQuorum
// };
