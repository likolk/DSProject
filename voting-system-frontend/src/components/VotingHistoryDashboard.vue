<template>
    <div>
      <h3>Voting History</h3>
      <div v-for="history in votingHistory" :key="history.proposalId">
        <p>Proposal: {{ history.title }}</p>
        <p>Outcome: {{ history.outcome }}</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref } from "vue";
  import Web3 from 'web3';

  
  export default {
    name: "VotingHistoryDashboard",
    data() {
      return {
        votingHistory: [],
      };
    },
    created() {
      this.fetchVotingHistory();
    },
    methods: {
      async fetchVotingHistory() {
        // Fetch voting history from smart contract
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = this.getVotingContract(provider);
        this.votingHistory = await contract.getVotingHistory();
      },
      getVotingContract(provider) {
        const contractAddress = "YOUR_CONTRACT_ADDRESS";
        const contractABI = []; // Add your contract ABI here
        return new ethers.Contract(contractAddress, contractABI, provider);
      },
    },
  };
  </script>
  