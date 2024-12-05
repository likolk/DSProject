<template>
  <div class="registration-container">
    <h3>Register Shareholder</h3>
    <button class="connect-btn" @click="connectWallet">Connect Wallet</button>
    <input v-model="shares" class="shares-input" type="number" placeholder="Enter number of shares" />
    <button class="register-btn" @click="registerShareholder">Register</button>
    <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

    <div v-if="tokens > 0">
      <p>Tokens available for voting: {{ tokens }}</p>
    </div>

  </div>
</template>

<script>
import { ref } from "vue";
import Web3 from "web3";
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";

console.log(window.ethereum);

if (!window.ethereum) {
  alert("Ethereum wallet not found. Please install MetaMask or another wallet.");
}

export default {
  name: "ShareholderRegistration",
  data() {
    return {
      shares: "",
      errorMessage: "",
      web3: null,
      contract: null,
      accounts: [],
      selectedAccount: null,
      requiredBalanceInEther: 0.1,
      tokens: 0,
    };
  },
  methods: {
    async connectWallet() {
  console.log("Connecting wallet...");
  if (window.ethereum) {
    console.log("Ethereum is available.");
    try {
      this.web3 = new Web3(window.ethereum);
      console.log("Web3 initialized:", this.web3);
      console.log("Current provider:", this.web3.currentProvider);
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      console.log("Connected accounts:", accounts);
      this.accounts = accounts;
      const selectedAccount = accounts[0];
      console.log("Selected account:", selectedAccount);
      this.selectedAccount = selectedAccount;

      await this.selectAccountWithBalance();

      const contractAddress = "0x410a52a849479E8Dc87B07d89e72483A4b3ca098";
      this.contract = new this.web3.eth.Contract(votingAbi.abi, contractAddress);
      console.log("Contract initialized:", this.contract);
    } catch (err) {
      console.error("Error connecting wallet:", err);
      this.errorMessage = "Please connect your Ethereum wallet.";
    }
  } else {
    alert("Ethereum wallet not found.");
  }
}
,

    async hasSufficientBalance(account) {
      try {
        const balanceInWei = await this.web3.eth.getBalance(account);
        const balanceInEther = this.web3.utils.fromWei(balanceInWei, 'ether');
        console.log(`Account balance: ${balanceInEther} ETH`);
        return parseFloat(balanceInEther) >= this.requiredBalanceInEther;
      } catch (err) {
        console.error("Error checking balance:", err);
        return false;
      }
    },

    // Try to select an account with sufficient balance
    async selectAccountWithBalance() {
      for (let i = 0; i < this.accounts.length; i++) {
        const account = this.accounts[i];
        const isBalanceSufficient = await this.hasSufficientBalance(account);

        if (isBalanceSufficient) {
          this.selectedAccount = account;
          console.log("Selected account:", this.selectedAccount);
          return;
        }
      }

      // If no account with sufficient balance is found
      this.errorMessage = "No account with sufficient balance found. Please ensure at least one account has enough funds.";
      console.log(this.errorMessage);
    },

    async registerShareholder() {
      if (this.shares > 100) {
  this.errorMessage = "You cannot register with more than 100 shares.";
  console.log("Shares exceed limit:", this.shares);
  return;
}


      console.log("Registering shareholder...");
      this.shares = Number(this.shares); 
      console.log("Shares value:", this.shares);

      if (!this.shares || this.shares <= 0) {
        this.errorMessage = "Please enter a valid number of shares.";
        console.log("Invalid shares:", this.shares);
        return;
      }

      if (!this.accounts.length) {
        this.errorMessage = "Please connect your wallet first.";
        console.log("No wallet connected. Accounts:", this.accounts);
        return;
      }

      if (!this.selectedAccount) {
        this.errorMessage = "No valid account selected with sufficient balance.";
        console.log("No valid account with balance found.");
        return;
      }

      console.log("Using account:", this.selectedAccount);

      try {
        const valueInWei = this.web3.utils.toWei('0.5', 'ether'); 

        // Register shareholder
        const tx = await this.contract.methods.registerShareholder(this.selectedAccount, this.shares).send({
          from: this.selectedAccount,
          value: valueInWei, 
        });

        console.log("Transaction sent:", tx);
        alert("Registration successful!");
        this.shares = "";  
        this.errorMessage = "";  
      } catch (err) {
        console.error("Registration failed:", err);
        this.errorMessage = `Registration failed. Error: ${err.message || 'Unknown error'}`;
      }
    },

    getVotingContract(signer) {
      const contractAddress = "0x410a52a849479E8Dc87B07d89e72483A4b3ca098";
      return new this.web3.eth.Contract(votingAbi.abi, contractAddress, signer);
    },

    async fetchTokens() {
      try {
        const tokens = await this.contract.methods.getTokens(this.selectedAccount).call();
        this.tokens = tokens; 
        console.log("Tokens available for voting:", this.tokens);
      } catch (err) {
        console.error("Error fetching tokens:", err);
      }
    }
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
.register-btn,
.add-btn,
.remove-btn {
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

.add-btn {
  background-color: #2196f3;
  color: white;
}

.add-btn:hover {
  background-color: #1e88e5;
}

.remove-btn {
  background-color: #f44336;
  color: white;
  margin-left: 10px;
}

.remove-btn:hover {
  background-color: #e53935;
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
