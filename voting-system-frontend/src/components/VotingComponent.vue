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
import { eventBus } from '@/services/eventBus';
import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";
import deployedAddress from "../../../voting-system-smart-contracts/scripts/deployedAddress.json";

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
                await contract.methods.castVote(proposalId, voteOption).send({ from:
                    'eth_accounts[0]'
                 });
                this.fetchProposals();
            } catch (err) {
                console.error("Voting failed:", err);
            }
        },
        async updateVotes() {
            const web3 = new Web3(window.ethereum);
            const contract = this.getVotingContract(web3);
            const progress = await contract.methods.getVotingProgress().call();
            this.totalVotes = progress;
        },
        async getVotingContract(web3) {
            console.log("Deployed Address JSON:", deployedAddress);
            const contractAddress = deployedAddress.address;
            console.log("Contract Address is finally:", contractAddress);
            return new web3.eth.Contract(votingAbi.abi, contractAddress);
        },
        async fetchProposals() {
    console.log("Fetching proposals Component VotingComponent");
    const web3 = new Web3(window.ethereum);
    try {
        const contract = await this.getVotingContract(web3); 
        const proposals = await contract.methods.getProposals().call();
        console.log("got proposals:", proposals);

        const { ids, titles, descriptions, votesForArray, votesAgainstArray, actives } = proposals;
        const proposalsList = ids.map((id, index) => ({
            id: id,
            title: titles[index],
            description: descriptions[index],
            votesFor: votesForArray[index],
            votesAgainst: votesAgainstArray[index],
            active: actives[index]
        }));

        console.log('Proposals:', proposalsList);
        this.proposals = proposalsList;  
    } catch (error) {
        console.error('Error fetching proposals:', error);
    }
}
    },
    mounted() {
        console.log("Abi content my friend:", votingAbi.abi);
    }
    ,
    async created() {
        if (window.ethereum) {
            const web3 = new Web3(window.ethereum);
            try {
                await window.ethereum.request({ method: "eth_requestAccounts" });
                this.fetchProposals();
            } catch (err) {
                console.error("Error connecting to wallet:", err);
                alert("Wallet connection failed.");
            }
        } else {
            alert("Please install MetaMask to interact with this application.");
        }
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
