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
        <!-- <p>Total Votes: {{ totalVotes }}%</p>
        <p v-if="votingStatus">Voting in Progress...</p> -->
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
        totalVotes: 0,
        votingStatus: false,
      };
    },
    mounted() {
        console.log("abi content:",  votingAbi.abi);
      this.initializeWallet();
      eventBus.on('newProposalCreated', this.fetchProposals); // Listen for the event
    },
    beforeDestroy() {
      // Remove event listener when the component is destroyed to prevent memory leaks
      eventBus.off('newProposalCreated', this.fetchProposals);
    },
    methods: {
      async vote(proposalId, voteOption) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(deployedAddress.address, votingAbi.abi, signer);
        try {
          await contract.castVote(proposalId, voteOption === 'yes').send({
            from: (await provider.listAccounts())[0],
            gasLimit: 500000 // Specify gas limit
          });
          this.fetchProposals();
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
          const proposals = await contract.getProposals({ gasLimit: 500000 }); // Specify gas limit
          console.log("Proposals fetched:", proposals);
  
          const proposalsList = proposals.map((proposal, index) => ({
            id: index,
            title: proposal.title,
            description: proposal.description,
            votesFor: proposal.votesFor.toString(), // Assuming BigNumber is returned
            votesAgainst: proposal.votesAgainst.toString(), // Assuming BigNumber is returned
            active: proposal.active,
            votingEndTime: proposal.votingEndTime.toString(), // If it's a timestamp
            quorumType: proposal.quorumType,
          }));
  
          console.log("Mapped Proposals:", proposalsList);
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