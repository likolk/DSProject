<template>
  <div class="voting-component">
    <h3>Vote on Proposals</h3>
    <div v-for="proposal in proposals" :key="proposal.id" class="proposal-item">
      <div class="proposal-header">
        <h4 class="proposal-title">{{ proposal.title }}</h4>
        <p class="proposal-description">{{ proposal.description }}</p>
      </div>
      <div class="proposal-details">
        <p class="details">Duration: {{ proposal.durationInMinutes }} minutes</p>
        <p class="details">Quorum: {{ getQuorumType(proposal.quorumType) }}</p>

      </div>
      <div class="vote-buttons">
        <button @click="vote(proposal.id, 'yes')" class="vote-button yes">Yes</button>
        <button @click="vote(proposal.id, 'no')" class="vote-button no">No</button>
        <button @click="deleteProposal(proposal.id)" class="delete-button">Delete</button>
      </div>
      <div class="vote-status">
        <p>Yes Votes: {{ proposal.votesFor }}</p>
        <p>No Votes: {{ proposal.votesAgainst }}</p>
      </div>
    </div>
  </div>
</template>
  
  <script>
  import { ref } from "vue";
  import { ethers } from "ethers";
  import { eventBus } from '@/services/eventBus';
  import votingAbi from "../../../voting-system-smart-contracts/artifacts/contracts/smartContract.sol/VotingContract.json";
  import deployedAddress from "../../../voting-system-smart-contracts/scripts/deployedAddress.json";
  
  export default {
    name: "VotingComponent",
    data() {
      return {
        proposals: [],
        // totalVotes: 0,
        // votingStatus: false,
      };
    },
    mounted() {
    console.log("ABI content:", votingAbi.abi);
    console.log("Deployed Address:", deployedAddress.address);

    // Initialize wallet and contract instance
    this.initializeWallet().then(() => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        this.contract = new ethers.Contract(deployedAddress.address, votingAbi.abi, signer);

        // Listen for events
        eventBus.on('newProposalCreated', this.fetchProposals); // Listen for the event
        this.contract.on("ProposalDeleted", this.fetchProposals);
    }).catch(err => {
        console.error("Error during wallet initialization:", err);
    });
},
beforeDestroy() {
    // Remove event listeners
    if (this.contract) {
        eventBus.off('newProposalCreated', this.fetchProposals);
        this.contract.off("ProposalDeleted", this.fetchProposals);
    }
},

    methods: {
      async vote(proposalId, voteOption) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(deployedAddress.address, votingAbi.abi, signer);
      try {
        await contract.castVote(proposalId, voteOption === 'yes');
        this.fetchProposals();  // Refresh the proposals list after voting
      } catch (err) {
        console.error("Voting failed:", err);
      }
    },
      async fetchProposals() {
        console.log("Fetching proposals in VotingComponent");
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const contract = new ethers.Contract(deployedAddress.address, votingAbi.abi, provider);
        try {
          console.log("Calling getProposals()");
          const proposals = await contract.getProposals();
          console.log("Proposals fetched:", proposals);
  
          const proposalsList = proposals.map((proposal, index) => ({
            id: index,
            title: proposal.title,
            description: proposal.description,
            votesFor: proposal.votesFor.toString(),
            votesAgainst: proposal.votesAgainst.toString(),
            active: proposal.active,
            votingEndTime: proposal.votingEndTime ? proposal.votingEndTime.toString() : "0",
            quorumType: proposal.quorumType,
            durationInMinutes: proposal.durationInMinutes.toString()
          }));

          // push new proposal to the list"
          const proposalList = []
          proposalsList.push(proposalList)
          console.log("Proposals List:", proposalsList);
          this.proposals = proposalsList;
      
        } catch (error) {
          console.error('Error fetching proposals:', error);
        }
      },
      async initializeWallet() {
        if (window.ethereum) {
          const provider = new ethers.providers.Web3Provider(window.ethereum);
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
      getQuorumType(quorumType) {
      switch (quorumType) {
        case 0:
          return "Simple Majority";
        case 1:
          return "Two-Thirds Majority";
        case 2:
          return "Three-Quarters Majority";
        case 3:
          return "Unanimous Majority";
        default:
          return "Unknown";
      }
    },
    // delete proposal function
    async deleteProposal(proposalId) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(deployedAddress.address, votingAbi.abi, signer);
        try {
          console.log("Deleting proposal with ID:", proposalId);
          await contract.deleteProposal(proposalId);
            this.fetchProposals();
        } catch (error) {
            console.error("Error deleting proposal:", error);
        }
    },
      
    },
  };
  </script>
  
  <style scoped>
.voting-component {
  font-family: 'Roboto', sans-serif;
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

.proposal-item {
  margin-bottom: 20px;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.proposal-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.proposal-header {
  margin-bottom: 15px;
}

.proposal-title {
  font-size: 1.5rem;
  color: #4A90E2;
  margin-bottom: 5px;
}

.proposal-description {
  font-size: 1rem;
  color: #555;
}

.proposal-details {
  margin-bottom: 15px;
}

.details {
  font-size: 0.9rem;
  color: #777;
}

.vote-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 10px;
}

.vote-button {
  flex: 1;
  padding: 10px 15px;
  font-size: 16px;
  border-radius: 8px;
  margin-right: 10px;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.3s;
  border: none;
}

.vote-button:last-child {
  margin-right: 0;
}

.vote-button.yes {
  background-color: #28a745;
  color: white;
}

.vote-button.yes:hover {
  background-color: #218838;
  transform: translateY(-2px);
}

.vote-button.no {
  background-color: #dc3545;
  color: white;
}

.vote-button.no:hover {
  background-color: #c82333;
  transform: translateY(-2px);
}

.vote-status {
  margin-top: 20px;
  text-align: center;
  font-size: 18px;
}

.vote-status p {
  font-weight: bold;
  color: #333;
}

.inactive {
    opacity: 0.6;
    pointer-events: none;
}

.inactive-label {
    text-align: center;
    color: #dc3545;
    font-weight: bold;
}
</style>