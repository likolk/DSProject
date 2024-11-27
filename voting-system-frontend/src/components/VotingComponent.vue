<template>
    <div>
      <h3>Vote on Proposals</h3>
      <div v-for="proposal in proposals" :key="proposal.id">
        <p>{{ proposal.title }}</p>
        <button @click="vote(proposal.id, 'yes')">Yes</button>
        <button @click="vote(proposal.id, 'no')">No</button>
      </div>
      <div>
        <p>Total Votes: {{ totalVotes }}%</p>
        <p v-if="votingStatus">Voting in Progress...</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref } from "vue";
  import Web3 from 'web3';


  
  export default {
    name: "VotingComponent",
    data() {
      return {
        proposals: [], // Fetch proposals from smart contract
        totalVotes: 0, // Percentage of total votes
        votingStatus: false, // True if voting is in progress
      };
    },
    methods: {
      async vote(proposalId, voteOption) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = this.getVotingContract(signer);
        
        try {
          await contract.castVote(proposalId, voteOption);
          this.updateVotes();
        } catch (err) {
          alert("Voting failed.");
        }
      },
      async updateVotes() {
        // Fetch updated voting progress from the contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = this.getVotingContract(provider);
        const progress = await contract.getVotingProgress();
        this.totalVotes = progress;
      },
      getVotingContract(provider) {
        const contractAddress = "YOUR_CONTRACT_ADDRESS";
        const contractABI = []; // Add your contract ABI here
        return new ethers.Contract(contractAddress, contractABI, provider);
      },
    },
    created() {
      this.fetchProposals();
    },
    methods: {
      async fetchProposals() {
        // Fetch proposals from smart contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = this.getVotingContract(provider);
        this.proposals = await contract.getProposals();
      }
    }
  };
  </script>
  