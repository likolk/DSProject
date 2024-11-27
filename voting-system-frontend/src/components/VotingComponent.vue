<template>
    <div>
        <h3>Vote on Proposals</h3>
        <div v-for="proposal in proposals" :key="proposal.id" class="proposal-item">
            <p>{{ proposal.title }}</p>
            <div class="vote-buttons">
                <button @click="vote(proposal.id, 'yes')" class="vote-button yes">Yes</button>
                <button @click="vote(proposal.id, 'no')" class="vote-button no">No</button>
            </div>
        </div>
        <div class="vote-status">
            <p>Total Votes: {{ totalVotes }}%</p>
            <p v-if="votingStatus">Voting in Progress...</p>
        </div>
    </div>
</template>

<script>
import { ref } from "vue";
import Web3 from 'web3';

export default {
    name: "VotingComponent",
    data() {
        return {
            proposals: [], 
            totalVotes: 0, 
            votingStatus: false, 
        };
    },
    methods: {
        async vote(proposalId, voteOption) {
            const web3 = new Web3(window.ethereum);
            const contract = this.getVotingContract(web3);
            
            try {
                await contract.methods.castVote(proposalId, voteOption).send({ from: window.ethereum.selectedAddress });
                this.updateVotes();
            } catch (err) {
                alert("Voting failed.");
            }
        },
        async updateVotes() {
            const web3 = new Web3(window.ethereum);
            const contract = this.getVotingContract(web3);
            const progress = await contract.methods.getVotingProgress().call();
            this.totalVotes = progress;
        },
        getVotingContract(web3) {
            const contractAddress = "0x71f13461195DaB07902cac189572a3d44d949253"; 
            const contractABI = [];
            return new web3.eth.Contract(contractABI, contractAddress);
        },
        async fetchProposals() {
            const web3 = new Web3(window.ethereum);
            const contract = this.getVotingContract(web3);
            this.proposals = await contract.methods.getProposals().call();
        }
    },
    created() {
        this.fetchProposals();
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

.proposal-item {
    margin-bottom: 20px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f9f9f9;
}

.vote-buttons {
    margin-top: 10px;
}

.vote-button {
    padding: 10px 15px;
    font-size: 16px;
    border-radius: 8px;
    margin-right: 10px;
    cursor: pointer;
    transition: background-color 0.3s;
    border: none;
}

.vote-button.yes {
    background-color: #28a745;
    color: white;
}

.vote-button.yes:hover {
    background-color: #218838;
}

.vote-button.no {
    background-color: #dc3545;
    color: white;
}

.vote-button.no:hover {
    background-color: #c82333;
}

.vote-status {
    margin-top: 20px;
    text-align: center;
    font-size: 18px;
}

.vote-status p {
    font-weight: bold;
}
</style>
