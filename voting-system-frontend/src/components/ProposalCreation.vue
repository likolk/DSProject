<template>
    <div>
        <h3>Create Proposal</h3>
        <div class="input-container">
            <input v-model="proposalTitle" placeholder="Proposal Title" class="input-field" />
            <textarea v-model="proposalDescription" placeholder="Proposal Description" class="input-field"></textarea>
        </div>
        <button @click="createProposal" class="create-button">Create Proposal</button>
    </div>
</template>

<script>
import { ref } from "vue";
import Web3 from "web3";

export default {
    name: "ProposalCreation",
    data() {
        return {
            proposalTitle: "",
            proposalDescription: "",
        };
    },
    methods: {
        async createProposal() {
            if (!this.proposalTitle || !this.proposalDescription) {
                alert("Please provide a title and description for the proposal.");
                return;
            }

            const web3 = new Web3(window.ethereum);
            const contract = this.getVotingContract(web3);

            try {
                await contract.methods.createProposal(this.proposalTitle, this.proposalDescription).send({ from: window.ethereum.selectedAddress });
                alert("Proposal created successfully!");
            } catch (err) {
                alert("Failed to create proposal.");
            }
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
