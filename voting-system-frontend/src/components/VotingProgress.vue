<template>
    <div>
      <h3>Voting Progress</h3>
      <div>
        <p>{{ progress }}% of total shares have voted.</p>
        <p v-if="progress >= 50">Quorum reached!</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref } from "vue";
  import Web3 from 'web3';


  
  export default {
    name: "VotingProgress",
    data() {
      return {
        progress: 0,
      };
    },
    created() {
      this.fetchVotingProgress();
    },
    methods: {
      async fetchVotingProgress() {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = this.getVotingContract(provider);
        this.progress = await contract.getVotingProgress();
      },
      getVotingContract(provider) {
        const contractAddress = "YOUR_CONTRACT_ADDRESS";
        const contractABI = []; // Add your contract ABI here
        return new ethers.Contract(contractAddress, contractABI, provider);
      },
    },
  };
  </script>
  