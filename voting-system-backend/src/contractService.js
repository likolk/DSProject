// logic to interact with smart contracts
const { ethers } = require("ethers");
const fs = require('fs'); 
const path = require('path');
require('dotenv').config();

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const contractABI = JSON.parse(fs.readFileSync(path.join(__dirname, '../..', 'artifacts', 'contracts', 'Lock.sol', 'Lock.json'))).abi; // the artifact generated by the Solidity smart contract when we compile it.
const contractAddress = process.env.CONTRACT_ADDRESS;

const contract = new ethers.Contract(contractAddress, contractABI.abi, signer);

async function registerVoter(address, shares) {
  const tx = await contract.registerVoter(address, shares);
  await tx.wait();
  return tx.hash; 
}

async function getProposalVotes(proposalId) {
  const votes = await contract.getProposalVotes(proposalId);
  return votes;
}

module.exports = { registerVoter, getProposalVotes };
