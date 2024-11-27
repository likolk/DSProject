<template>
    <div>
      <h3>Voting Progress</h3>
      <div class="progress-container">
        <p class="progress-text">{{ progress }}% of total shares have voted.</p>
        <p v-if="progress >= 50" class="quorum-reached">Quorum reached!</p>
      </div>
    </div>
</template>

<script>
import { ref } from "vue";
import Web3 from "web3";

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
      const web3 = new Web3(window.ethereum);
      const contract = this.getVotingContract(web3);
      this.progress = await contract.methods.getVotingProgress().call();
    },
    getVotingContract(web3) {
      const contractAddress = "0x71f13461195DaB07902cac189572a3d44d949253"; 
      const contractABI = []; 
      return new web3.eth.Contract(contractABI, contractAddress);
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

.progress-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 20px;
}

.progress-text {
  font-size: 18px;
  margin: 10px 0;
  padding: 10px;
  background-color: #e8f7ff;
  border-radius: 8px;
  width: 80%;
  max-width: 600px;
  text-align: center;
}

.quorum-reached {
  font-size: 18px;
  margin: 10px 0;
  padding: 10px;
  background-color: #d1f7d1;
  color: #007b00;
  font-weight: bold;
  border-radius: 8px;
  width: 80%;
  max-width: 600px;
  text-align: center;
}
</style>
