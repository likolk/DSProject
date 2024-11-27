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
  import Web3 from "web3";
  
  export default {
    name: "VotingHistoryDashboard",
    data() {
      return {
        votingHistory: [],
        web3: null,
        contract: null,
      };
    },
    created() {
      this.fetchVotingHistory();
    },
    methods: {
      async fetchVotingHistory() {
        if (!this.web3) {
          this.web3 = new Web3(window.ethereum); // Initialize Web3 instance
        }
        const accounts = await this.web3.eth.getAccounts();
        const contract = this.getVotingContract();
        
        // Fetch voting history from the smart contract
        try {
          const history = await contract.methods.getVotingHistory().call({ from: accounts[0] });
          this.votingHistory = history;
        } catch (err) {
          console.error("Error fetching voting history:", err);
        }
      },
      getVotingContract() {
        const contractAddress = "0x71f13461195DaB07902cac189572a3d44d949253";
        const contractABI = []; 
        return new this.web3.eth.Contract(contractABI, contractAddress);
      },
    },
  };
  </script>
<style scoped>
h3 {
  text-align: center;
  margin-bottom: 20px;
  font-size: 24px;
  color: #333;
}

div {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 20px;
}

div p {
  font-size: 18px;
  margin: 10px 0;
  padding: 10px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  width: 80%;
  max-width: 600px;
  text-align: left;
}

div p:nth-child(even) {
  background-color: #f1f1f1;
}

div p span {
  font-weight: bold;
  color: #007bff;
}

</style>
  