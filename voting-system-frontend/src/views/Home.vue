<template>
  <div class="home">
    <h1 :style="headerStyle">Decentralized Voting System</h1>

    <section class="card">
      <h2>Profile</h2>
      <div v-if="userProfile" class="profile-card">
        <h3>{{ userProfile.name }}</h3>
        <p><strong>Wallet:</strong> {{ userProfile.wallet }}</p>
        <p><strong>ETH Balance:</strong> {{ userProfile.ethBalance }} ETH</p>
      </div>
      <div v-else>
        <button @click="loadUserProfile" class="cta-button">Connect Wallet</button>
      </div>
    </section>

    <section class="card">
      <h2>Register as Shareholder</h2>
      <ShareholderRegistration />
    </section>

    <section class="card">
      <h2>Vote on Proposals</h2>
      <VotingComponent />
    </section>

    <section class="card">
      <h2>Create Proposal</h2>
      <ProposalCreation />
    </section>

    <section class="card">
      <h2>Voting History</h2>
      <VotingHistoryDashboard />
    </section>

    <section class="card">
      <h2>Voting Statistics</h2>
      <canvas id="votingChart"></canvas>
    </section>
  </div>
</template>

<script>
import ShareholderRegistration from "@/components/ShareholderRegistration.vue";
import VotingComponent from "@/components/VotingComponent.vue";
import ProposalCreation from "@/components/ProposalCreation.vue";
import VotingHistoryDashboard from "@/components/VotingHistoryDashboard.vue";
import Web3 from "web3";
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";
import Chart from "chart.js/auto";
import deployedAddress from "../../../voting-system-smart-contracts/scripts/deployedAddress.json";



export default {
  name: "Home",
  components: {
    ShareholderRegistration,
    VotingComponent,
    ProposalCreation,
    VotingHistoryDashboard,
  },
  data() {
    return {
      userProfile: null,
      web3: null,
      contract: null,
      colors: [
        "#4A90E2", "#50E3C2", "#B8E986", "#F5A623", "#D0021B", "#9013FE", "#8B572A"
      ],
      currentColorIndex: 0,
      headerStyle: {
        transition: "color 1s ease-in-out, background 1s ease-in-out",
        color: "#333",
        background: "linear-gradient(90deg, #4A90E2, #50E3C2)",
      }
    };
  },
  async created() {
    this.web3 = new Web3(window.ethereum);
    this.contract = this.getVotingContract(this.web3);
    await this.loadUserProfile();
    window.ethereum.on('accountsChanged', this.handleAccountChange);
    this.initializeChart();
  },
  beforeDestroy() {
    window.ethereum.removeListener('accountsChanged', this.handleAccountChange);
  },
  methods: {
    getVotingContract(web3) {
      const contractAddress = deployedAddress.address;
      const contractABI = votingAbi.abi;
      console.log("votingAbi", votingAbi);
      return new web3.eth.Contract(contractABI, contractAddress);
    },

    async loadUserProfile() {
      try {
        console.log("Attempting to load user profile...");
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        console.log("Accounts:", accounts);

        const chainId = await this.web3.eth.getChainId();
        if (parseInt(chainId) !== 31337) {
          console.error("Please switch to the Hardhat network (chain ID 31337) in MetaMask.");
        }
        console.log("Connected to chain ID:", chainId);

        if (!accounts || accounts.length === 0) {
          console.error("No accounts found. Ensure your wallet is connected.");
          return;
        }

        const wallet = accounts[0]; 
        console.log("User Wallet:", wallet);

        const balanceWei = await this.web3.eth.getBalance(wallet);
        const balanceEth = this.web3.utils.fromWei(balanceWei, "ether");
        console.log("ETH Balance:", balanceEth);

        this.userProfile = {
          name: wallet,
          wallet,
          ethBalance: balanceEth
        };
        console.log("User profile loaded:", this.userProfile);
      } catch (error) {
        console.error("Error loading user profile:", error);
      }
    },
    // This method is called when the account changes
    async handleAccountChange(accounts) {
      if (accounts.length === 0) {
        console.log("Disconnected");
        this.userProfile = null; // Clear the user profile if no account is selected
      } else {
        console.log("Account changed", accounts[0]);
        await this.loadUserProfile(); // Reload user profile with the new account
      }
    },
    startColorChangeInterval() {
      setInterval(() => {
        // Update color and gradient
        this.currentColorIndex = (this.currentColorIndex + 1) % this.colors.length;
        const newColor = this.colors[this.currentColorIndex];

        // Set a new color and gradient for the title
        this.headerStyle.color = newColor;
        this.headerStyle.background = `linear-gradient(90deg, ${newColor}, #50E3C2)`;
      }, Math.floor(Math.random() * (5000 - 2000 + 1)) + 2000); // Random interval between 2-5 seconds
    },
    initializeChart() {
      const ctx = document.getElementById('votingChart').getContext('2d');
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['Proposal 1', 'Proposal 2', 'Proposal 3'],
          datasets: [
            {
              label: 'Votes For',
              data: [100, 50, 30],
              backgroundColor: '#4A90E2',
            },
            {
              label: 'Votes Against',
              data: [20, 70, 10],
              backgroundColor: '#D0021B',
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });
    },
  }
};
</script>

<style scoped>
.home {
  font-family: "Arial", sans-serif;
  padding: 20px;
  background: linear-gradient(135deg, #4A90E2, #50E3C2);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 40px;
}

h1 {
  text-align: center;
  font-size: 3rem;
  color: #fff;
  margin-bottom: 40px;
  font-weight: 700;
  letter-spacing: 1px;
  padding: 10px 20px;
  border-radius: 10px;
  background: linear-gradient(90deg, #4A90E2, #50E3C2);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

section.card {
  background: linear-gradient(135deg, #ffffff, #f1f1f1);
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 800px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

section.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

section h2 {
  margin-bottom: 15px;
  font-size: 1.8rem;
  color: #4A90E2;
  font-weight: 600;
  text-align: center;
  border-bottom: 2px solid #4A90E2;
  padding-bottom: 10px;
}

.profile-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background: #f9f9f9;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.profile-card h3 {
  font-size: 1.5rem;
  color: #4A90E2;
  margin-bottom: 10px;
}

.profile-card p {
  font-size: 1rem;
  color: #555;
  margin: 5px 0;
}

.cta-button {
  padding: 15px 30px;
  font-size: 1.2rem;
  color: white;
  background-color: #4A90E2;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.cta-button:hover {
  background-color: #357ABD;
}
</style>