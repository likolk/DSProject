<template>
    <div class="registration-container">
      <h3>Register Shareholder</h3>
      <button class="connect-btn" @click="connectWallet">Connect Wallet</button>
      <input v-model="shares" class="shares-input" type="number" placeholder="Enter number of shares" />
      <button class="register-btn" @click="registerShareholder">Register</button>
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
            web3: null,
            contract: null,
        };
    },
    methods: {
      async connectWallet() {
        if (window.ethereum) {
          try {
            this.web3 = new Web3(window.ethereum);
            await window.ethereum.request({ method: "eth_requestAccounts" });
          } catch (err) {
            this.errorMessage = "Please connect your Ethereum wallet.";
          }
        } else {
          alert("Ethereum wallet not found.");
        }
      },
      async registerShareholder() {
            if (!this.shares || this.shares <= 0) {
                this.errorMessage = "Please enter a valid number of shares.";
                return;
            }

            if (!this.accounts.length) {
                this.errorMessage = "Please connect your wallet first.";
                return;
            }

            try {
                const shareholderAddress = this.accounts[0];
                const tx = await this.contract.methods.registerShareholder(shareholderAddress, this.shares).send({ from: shareholderAddress });
                alert("Registration successful!");
            } catch (err) {
                this.errorMessage = "Registration failed.";
            }
        },
      getVotingContract(signer) {
        const contractAddress = "0x71f13461195DaB07902cac189572a3d44d949253";
        const contractABI = [];
        return new Web3.eth.Contract(contractABI, contractAddress, signer);
      },
    },
  };
  </script>
  
  <style scoped>
  .registration-container {
    background-color: #f4f7fa;
    border-radius: 8px;
    padding: 30px;
    width: 100%;
    max-width: 400px;
    margin: auto;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  h3 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
  }
  
  .connect-btn,
  .register-btn {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    border: none;
    border-radius: 4px;
    margin-bottom: 15px;
    cursor: pointer;
    transition: background-color 0.3s;
  }
  
  .connect-btn {
    background-color: #3b5998;
    color: white;
  }
  
  .connect-btn:hover {
    background-color: #2d4373;
  }
  
  .register-btn {
    background-color: #4caf50;
    color: white;
  }
  
  .register-btn:hover {
    background-color: #45a049;
  }
  
  .shares-input {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 4px;
    border: 1px solid #ccc;
    font-size: 16px;
  }
  
  .error {
    color: red;
    font-size: 14px;
    text-align: center;
    margin-top: 10px;
  }
  </style>
  