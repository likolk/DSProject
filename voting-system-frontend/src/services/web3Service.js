import Web3 from "web3";
import VotingContractABI from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";

console.log("VotingContractABI:", VotingContractABI);  

const web3 = new Web3(Web3.givenProvider || "http://127.0.0.1:8545");
const contractAddress = "0x9fD895aF7F241BfAC2a9d3EC4D08ddDaCBc857ab";
const contract = new web3.eth.Contract(VotingContractABI.abi || VotingContractABI, contractAddress);
console.log("VotingContractABI:", VotingContractABI);

export default {
  async createProposal(proposalTitle, proposalDescription, votingDeadline, quorumType) {
    const accounts = await web3.eth.getAccounts();
    const currentTime = Math.floor(Date.now() / 1000);
    const votingDuration = Math.floor((new Date(votingDeadline).getTime() / 1000) - currentTime);
    const quorum = parseInt(quorumType);

    try {
      await contract.methods.createProposal(proposalTitle, proposalDescription, votingDuration, quorum).send({ from: accounts[0] });
      alert("Proposal Created!");
    } catch (error) {
      console.error("Error creating proposal:", error);
      alert(`Error creating proposal: ${error.message || error}`);
    }
  },

  async vote(proposalId, voteFor) {
    const accounts = await web3.eth.getAccounts();
    try {
      await contract.methods.vote(proposalId, voteFor).send({ from: accounts[0] });
      alert("Vote cast successfully!");
    } catch (error) {
      console.error(error);
      alert("Error casting vote.");
    }
  },

  async getProposalOutcome(proposalId) {
    const outcome = await contract.methods.getProposalOutcome(proposalId).call();
    return outcome;
  },

};
