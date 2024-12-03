<template>
  <div class="proposal-creation">
    <div v-if="isAdmin">
      <h3>Create Proposal</h3>
      <div class="input-container">
        <input v-model="proposalTitle" placeholder="Proposal Title" class="input-field" />
        <textarea v-model="proposalDescription" placeholder="Proposal Description" class="input-field"></textarea>
        <input v-model.number="durationInMinutes" type="number" placeholder="Duration (in minutes)" class="input-field" />
        <select v-model="quorumType" class="input-field">
          <option disabled value="">Select Quorum Type</option>
          <option value="0">Simple Majority</option>
          <option value="1">Two-Thirds Majority</option>
          <option value="2">Three-Quarters Majority</option>
          <option value="3">Unanimous Majority</option>
        </select>
      </div>
      <button @click="createProposal" class="create-button">Create Proposal</button>
    </div>

    <div v-else>
      <p>You do not have permission to create proposals.</p>
    </div>
  </div>
</template>

<script>
import { ethers } from "ethers"; 
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";
import { eventBus } from '@/services/eventBus';
import deployedAddress from "../../../voting-system-smart-contracts/scripts/deployedAddress.json";

export default {
  name: "ProposalCreation",
  data() {
    return {
      isAdmin: true,
      proposalTitle: "",
      proposalDescription: "",
      durationInMinutes: null,
      quorumType: "",
      contractAddress: deployedAddress.address,
    };
  },
  methods: {
    async checkAdminStatus() {
      const accounts = await window.ethereum.request({ method: 'eth_accounts' });
      const selectedAddress = accounts[0]; 
      console.log("Selected Address:", selectedAddress);

      const provider = new ethers.providers.Web3Provider(window.ethereum); 
      const signer = provider.getSigner();
      const contract = new ethers.Contract(this.contractAddress, votingAbi.abi, signer);
      console.log("Contract object:", contract);

      const initialAdmins = [
        '0xdD2FD4581271e230360230F9337D5c0430Bf44C0',
        '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199',
        '0xbda5747bfd65f08deb54cb465eb87d40e51b197e',
        '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'
      ];

      const normalizedSelectedAddress = selectedAddress.toLowerCase().trim();
      const normalizedInitialAdmins = initialAdmins.map(address => address.toLowerCase().trim());

      console.log("Normalized Selected Address:", normalizedSelectedAddress);
      console.log("Normalized Initial Admins:", normalizedInitialAdmins);

      this.isAdmin = normalizedInitialAdmins.includes(normalizedSelectedAddress);

      if (this.isAdmin) {
        console.log("Selected Address is an admin.");
        return;
      } else {
        console.log("Selected Address is not an admin.");
      }

      try {
        const isAdmin = await contract.isAdmin(selectedAddress);
        console.log("Admin check result:", isAdmin);
        this.isAdmin = isAdmin;
      } catch (error) {
        console.error("Error checking admin status:", error);
        this.isAdmin = false;
      }
    },

    async createProposal() {
      if (!this.proposalTitle || !this.proposalDescription) {
        alert("Please provide a title and description for the proposal.");
        return;
      }
      if (!this.durationInMinutes || this.durationInMinutes <= 0) {
        alert("Please specify a valid duration in minutes.");
        return;
      }
      if (this.quorumType === "") {
        alert("Please select a quorum type.");
        return;
      }

      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(this.contractAddress, votingAbi.abi, signer);

      try {
        const valueInWei = ethers.utils.parseEther('1'); // Convert 1 ETH to Wei using ethers

        const tx = await contract.createProposal(
          this.proposalTitle,
          this.proposalDescription,
          this.durationInMinutes,
          this.quorumType,
          { value: valueInWei, gasLimit: 500000 }
        );

        console.log("Transaction receipt:", tx); // Log the transaction receipt for debugging
        // Emit event when the proposal is successfully created
        eventBus.emit('newProposalCreated');
        alert("Proposal created successfully!");
      } catch (err) {
        console.error("Error while creating proposal:", err);
        alert("Failed to create proposal. Please check the console for more details.");
      }
    }
  },

  async mounted() {
    await this.checkAdminStatus();
  },
};
</script>

<style scoped>
.proposal-creation {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  max-width: 800px;
  margin: 0 auto;
}

h3 {
  text-align: center;
  margin-bottom: 20px;
  font-size: 2rem;
  color: #333;
  font-weight: 700;
  letter-spacing: 1px;
}

.input-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
}

.input-field {
  width: 80%;
  max-width: 600px;
  padding: 10px;
  font-size: 16px;
  border-radius: 8px;
  border: 1px solid #ddd;
  margin-top: 10px;
  outline: none;
  transition: border-color 0.3s;
}

.input-field:focus {
  border-color: #007bff;
}

.create-button {
  padding: 12px 20px;
  background-color: #28a745;
  color: white;
  font-size: 16px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.3s;
  width: 80%;
  max-width: 600px;
}

.create-button:hover {
  background-color: #218838;
  transform: translateY(-2px);
}

.create-button:active {
  background-color: #1e7e34;
  transform: translateY(0);
}

p {
  text-align: center;
  font-size: 1.2rem;
  color: #ff0000;
  font-weight: 600;
}
</style>