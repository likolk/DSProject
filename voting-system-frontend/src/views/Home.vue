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
        <button @click="loadUserProfile">Connect Wallet</button>
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

    <!-- <section class="card">
      <h2>Voting Progress</h2>
      <VotingProgress />
    </section> -->
  </div>
</template>


<script>
import ShareholderRegistration from "@/components/ShareholderRegistration.vue";
import VotingComponent from "@/components/VotingComponent.vue";
import ProposalCreation from "@/components/ProposalCreation.vue";
import VotingHistoryDashboard from "@/components/VotingHistoryDashboard.vue";
// import VotingProgress from "@/components/VotingProgress.vue";
import Web3 from "web3";
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";

export default {
  name: "Home",
  components: {
    ShareholderRegistration,
    VotingComponent,
    ProposalCreation,
    VotingHistoryDashboard,
    // VotingProgress
  },
  data() {
  return {
    userProfile: null,
    web3: null,
    contract: null,
    colors: [
      "#FF6347", "#40E0D0", "#8A2BE2", "#FFD700", "#32CD32", "#FF1493", "#00BFFF"
    ], 
    currentColorIndex: 0,
    headerStyle: {
      transition: "color 1s ease-in-out, background 1s ease-in-out", 
      color: "#333",
      background: "linear-gradient(90deg, #FF6347, #40E0D0)", 
    }
  };
},
  async created() {
    this.web3 = new Web3(window.ethereum);
    this.contract = this.getVotingContract(this.web3);
    
    // Load user profile
    await this.loadUserProfile();
    
    // Listen for account changes
    window.ethereum.on('accountsChanged', this.handleAccountChange);
  },
  beforeDestroy() {
    // Remove the event listener when the component is destroyed
    window.ethereum.removeListener('accountsChanged', this.handleAccountChange);
  },
  methods: {
    getVotingContract(web3) {
      const contractAddress = "0x18Ae637480be5c43fcd46373016b2D18dCd95f96";
      const contractABI = votingAbi.abi;
      console.log("votingAbi", votingAbi);
      return new web3.eth.Contract(contractABI, contractAddress);
    },
    async loadUserProfile() {
  try {
    console.log("Attempting to load user profile...");
    const accounts = await this.web3.eth.requestAccounts(); // Request wallet connection
    console.log("Accounts:", accounts);

    if (!accounts || accounts.length === 0) {
      console.error("No accounts found. Ensure your wallet is connected.");
      return;
    }

    const wallet = accounts[0]; // The wallet address of the logged-in user
    console.log("User Wallet:", wallet);

    // Fetch the user's ETH balance in Wei and convert it to ETH
    const balanceWei = await this.web3.eth.getBalance(wallet);
    const balanceEth = this.web3.utils.fromWei(balanceWei, "ether");
    console.log("ETH Balance:", balanceEth);

    // Set the user profile with wallet address and ETH balance
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
      this.headerStyle.background = `linear-gradient(90deg, ${newColor}, #40E0D0)`;
    }, Math.floor(Math.random() * (5000 - 2000 + 1)) + 2000); // Random interval between 2-5 seconds
  },
  }
};
</script>

<style scoped>
.home {
  font-family: "Arial", sans-serif;
  padding: 20px;
  background-color: #00eee6;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 40px;
}

h1 {
  text-align: center;
  font-size: 2.5rem;
  color: #333;
  margin-bottom: 40px;
  font-weight: 700;
  letter-spacing: 1px;
}

section.card {
  background-color: white;
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
  font-size: 1.5rem;
  color: #4a90e2;
  font-weight: 600;
}

.profile-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  background: #f9f9f9;
}

.profile-card h3 {
  font-size: 1.5rem;
  color: #4a90e2;
  margin-bottom: 10px;
}

.profile-card p {
  font-size: 1rem;
  color: #555;
  margin: 5px 0;
}
</style>
