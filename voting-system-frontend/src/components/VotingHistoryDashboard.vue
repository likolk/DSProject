<template>
  <div>
    <h3>Voting History</h3>
    <div v-for="history in votingHistory" :key="history.proposalId" class="history-card">
      <h4>{{ history.title }}</h4>
      <p><strong>Description:</strong> {{ history.description }}</p>
      <p><strong>Outcome:</strong> 
        <span :class="{'passed': history.outcome === 'Passed', 'failed': history.outcome === 'Failed', 'ongoing': history.outcome === 'Ongoing'}">
          {{ history.outcome }}
        </span>
      </p>
      <p><strong>Votes For:</strong> {{ history.votesFor }}</p>
      <p><strong>Votes Against:</strong> {{ history.votesAgainst }}</p>
      <p><strong>Voting Period:</strong> {{ history.startTime }} to {{ history.endTime }}</p>
      <p><strong>Quorum Met:</strong> {{ history.quorumMet ? "Yes" : "No" }}</p>
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
      // this.fetchVotingHistory();
    },

    async fetchVotingHistory() {
      try {
        const proposalCount = await this.contract.methods.getProposalsCount().call();
        for (let i = 0; i < proposalCount; i++) {
          const proposal = await this.contract.methods.proposals(i).call();
          const outcome = await this.contract.methods.getProposalOutcome(i).call();
          const quorumInfo = await this.contract.methods.getVotingProgress(i).call();

          this.votingHistory.push({
            proposalId: i,
            title: proposal.title,
            description: proposal.description,
            outcome: proposal.active
              ? "Ongoing"
              : outcome.passed
              ? "Passed"
              : "Failed",
            votesFor: outcome.votesFor,
            votesAgainst: outcome.votesAgainst,
            startTime: new Date(proposal.votingEndTime * 1000 - proposal.votingEndTime * 60000).toLocaleString(),
            endTime: new Date(proposal.votingEndTime * 1000).toLocaleString(),
            quorumMet: quorumInfo.progress >= quorumInfo.requiredQuorum,
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

.history-card {
  background-color: #f9f9f9;
  border-radius: 10px;
  padding: 15px;
  margin: 10px auto;
  max-width: 600px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.history-card h4 {
  margin: 0;
  font-size: 20px;
  color: #555;
}

.history-card p {
  font-size: 16px;
  margin: 5px 0;
}

.passed {
  color: green;
  font-weight: bold;
}

.failed {
  color: red;
  font-weight: bold;
}

.ongoing {
  color: orange;
  font-weight: bold;
}
</style>
