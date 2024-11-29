<template>
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

</template>

<script>
import { ref } from "vue";
import Web3 from "web3";
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";
import { eventBus } from '@/services/eventBus';
import { address } from "../../../voting-system-smart-contracts/scripts/deployedAddress.json";


export default {
  name: "ProposalCreation",
  data() {
    return {
      isAdmin: false,
      proposalTitle: "",
      proposalDescription: "",
      durationInMinutes: null,
      quorumType: "",
    };
  },
  methods: {
    async checkAdminStatus() {
      const accounts = await window.ethereum.request({ method: 'eth_accounts' });
      const selectedAddress = accounts[0]; 
      console.log("Selected Address:", selectedAddress);
      const web3 = new Web3(window.ethereum);

  const contractAddress = address;
  console.log("Contract Address: ", contractAddress);

  const contract = this.getVotingContract(web3, contractAddress);
  console.log("Contract object:", contract);



  console.log("Selected Address isssissiisisisis:", selectedAddress);

  const initialAdmins = [
        '0x71f13461195DaB07902cac189572a3d44d949253',
        '0x92639568a4B35c4052A2243b51f75A3065104D8d',
        '0xeD8A727F4A3447ba80Bd82Fcdc37121462A512De',
    ];

  console.log("Initial Admins arereerreer:", initialAdmins);

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
    const isAdmin = await contract.methods.isAdmin(selectedAddress).call();
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

      const web3 = new Web3(window.ethereum);
      const contract = this.getVotingContract(web3);


      const valueInWei = web3.utils.toWei('1', 'ether');

      try {
        await contract.methods
          .createProposal(
            this.proposalTitle,
            this.proposalDescription,
            this.durationInMinutes,
            this.quorumType
          )
          .send({
            from: window.ethereum.selectedAddress,
            value: valueInWei, 
          });
        // Emit event to notify VotingComponent to fetch proposals
        eventBus.emit('newProposalCreated');
        alert("Proposal created successfully!");
      } catch (err) {
        alert("Failed to create proposal.");
        console.error(err);
      }
    },
    getVotingContract(web3) {
      return new web3.eth.Contract(votingAbi.abi, address);
    },
  },
  mounted() {

    this.checkAdminStatus();
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
  transition: background-color 0.3s;
  width: 80%;
  max-width: 600px;
}

.create-button:hover {
  background-color: #218838;
}
</style>
