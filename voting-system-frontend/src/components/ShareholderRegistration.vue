<template>
    <div>
      <h3>Register Shareholder</h3>
      <button @click="connectWallet">Connect Wallet</button>
      <input v-model="shares" type="number" placeholder="Enter number of shares" />
      <button @click="registerShareholder">Register</button>
      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    </div>
  </template>
  
  <script>
  import { ref } from "vue";
  import Web3 from 'web3';


  
  export default {
    name: "ShareholderRegistration",
    data() {
      return {
        shares: "",
        errorMessage: "",
      };
    },
    methods: {
      async connectWallet() {
        if (window.ethereum) {
          try {
            await window.ethereum.request({ method: "eth_requestAccounts" });
          } catch (err) {
            this.errorMessage = "Please connect your Ethereum wallet.";
          }
        } else {
          this.errorMessage = "Ethereum wallet not found.";
        }
      },
      async registerShareholder() {
        if (!this.shares || this.shares <= 0) {
          this.errorMessage = "Please enter a valid number of shares.";
          return;
        }
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const shareholderAddress = await signer.getAddress();
        const contract = this.getVotingContract(signer);
  
        try {
          await contract.registerShareholder(shareholderAddress, this.shares);
          alert("Registration successful!");
        } catch (err) {
          this.errorMessage = "Registration failed.";
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
  
  <style scoped>
  .error {
    color: red;
  }
  </style>
  