<template>
    <div>
      <h3>Create Proposal</h3>
      <input v-model="proposalTitle" placeholder="Proposal Title" />
      <textarea v-model="proposalDescription" placeholder="Proposal Description"></textarea>
      <button @click="createProposal">Create Proposal</button>
    </div>
  </template>
  
  <script>
  import { ref } from "vue";
  import Web3 from 'web3';


  
  export default {
    name: "ProposalCreation",
    data() {
      return {
        proposalTitle: "",
        proposalDescription: "",
      };
    },
    methods: {
      async createProposal() {
        if (!this.proposalTitle || !this.proposalDescription) {
          alert("Please provide a title and description for the proposal.");
          return;
        }
  
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = this.getVotingContract(signer);
  
        try {
          await contract.createProposal(this.proposalTitle, this.proposalDescription);
          alert("Proposal created successfully!");
        } catch (err) {
          alert("Failed to create proposal.");
        }
      },
      getVotingContract(signer) {
        const contractAddress = "YOUR_CONTRACT_ADDRESS";
        const contractABI = []; // Add your contract ABI here
        return new ethers.Contract(contractAddress, contractABI, signer);
      },
    },
  };
  </script>
  