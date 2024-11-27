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
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";

export default {
  name: "VotingHistoryDashboard",
  data() {
    return {
      votingHistory: [],
      web3: null,
      contract: null,
      account: "",
    };
  },
  created() {
    this.initializeWeb3();
  },
  methods: {
    async initializeWeb3() {
      if (!this.web3) {
        this.web3 = new Web3(window.ethereum); 
      }
      const accounts = await this.web3.eth.getAccounts();
      this.account = accounts[0];
      this.contract = this.getVotingContract();
      this.fetchVotingHistory();
    },

    async fetchVotingHistory() {
      try {
        const votingRecords = await this.contract.methods.votingHistory(this.account).call();
        for (let i = 0; i < votingRecords.length; i++) {
          const record = votingRecords[i];
          const proposal = await this.contract.methods.proposals(record.proposalId).call();

          const outcome = await this.contract.methods.getProposalOutcome(record.proposalId).call();

          this.votingHistory.push({
            proposalId: record.proposalId,
            title: proposal.title,
            outcome: outcome.passed ? "Passed" : "Failed",
          });
        }
      } catch (err) {
        console.error("Error fetching voting history:", err);
      }
    },

    getVotingContract() {
      const contractAddress = "0x4Bc8f45D2e7CA3f23d593fFd25FBdc9E19B3F89f";
      return new this.web3.eth.Contract(votingAbi.abi, contractAddress);
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
