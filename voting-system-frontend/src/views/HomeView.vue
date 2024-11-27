<template>
  <div class="governance-platform">
    <header class="header">
      <nav>
      <h1>Decentralized Governance Platform</h1>
      <div class="navbar-menu">
        <router-link to="/" class="navbar-item active">
          Dashboard
        </router-link>
        <router-link to="/create-proposal" class="navbar-item">
          Create Proposal
        </router-link>
        <a href="#" class="navbar-item" @click="handleProfile">
          Profile
        </a>
        <a href="#" class="navbar-item" @click="handleLogout">
          Logout
        </a>
      </div>
    </nav>
    </header>

    <div class="container">
      <div class="dashboard-header">
        <div class="dashboard-title">
          <h2>Proposal Dashboard</h2>
          <p>Explore and participate in active governance proposals</p>
        </div>
        <button class="create-btn" @click="navigateToCreateProposal">
          Create Proposal
        </button>
      </div>

      <table class="proposals-table">
        <thead>
          <tr>
            <th>Proposal Details</th>
            <th>Voting Options</th>
            <th>Voting Results</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="proposal in proposals" :key="proposal.id">
            <td>
              <div>
                <button 
                  class="proposal-title" 
                  @click="showProposalDetails(proposal.id)"
                >
                  {{ proposal.title }}
                </button>
                <span 
                  class="proposal-status" 
                  :class="getStatusClasses(proposal.status)"
                >
                  {{ capitalizeFirstLetter(proposal.status) }}
                </span>
                <p class="text-sm">{{ proposal.description }}</p>
              </div>
            </td>
            <td>
              <button 
                v-for="option in proposal.options" 
                :key="option.id" 
                class="vote-btn" 
                @click="showOptionDetails(option.id)"
              >
                {{ option.name }}
              </button>
            </td>
            <td>
              <div v-for="option in proposal.options" :key="option.id">
                <div class="vote-progress">
                  <div 
                    class="vote-progress-bar"
                    :style="{
                      width: `${(option.votes / totalVotes(proposal)) * 100}%`, 
                      backgroundColor: '#4f46e5'
                    }"
                  ></div>
                </div>
                <span>{{ option.votes }} votes</span>
              </div>
            </td>
            <td>
              <button 
                v-for="option in proposal.options" 
                :key="option.id" 
                class="vote-btn" 
                @click="vote(proposal.id, option.id)"
                :disabled="proposal.status !== 'ongoing'"
              >
                Vote
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      proposals: [],
      initialProposals: [
        {
          id: 1,
          title: 'Investment Strategy Selection',
          description: 'Please choose the investment portfolio you think is most suitable.',
          status: 'ongoing',
          creationDate: '2023-09-01',
          deadline: '2023-09-30',
          options: [
            { id: 1, name: 'Stocks', votes: 50, details: 'Stocks are securities representing ownership in a company.' },
            { id: 2, name: 'Bonds', votes: 30, details: 'Bonds are debt securities issued by companies or governments.' },
            { id: 3, name: 'Mixed Funds', votes: 20, details: 'Mixed funds invest in a combination of stocks and bonds.' }
          ],
          userVotingWeight: 5
        },
        {
          id: 2,
          title: 'Company Strategy Adjustment',
          description: 'Please choose the future development direction of the company.',
          status: 'ongoing',
          creationDate: '2023-08-15',
          deadline: '2023-09-15',
          options: [
            { id: 4, name: 'Expand Overseas Markets', votes: 40, details: 'Expanding overseas markets helps the company globalize.' },
            { id: 5, name: 'Focus on Domestic Business', votes: 60, details: 'Focusing on domestic business can consolidate the existing market.' }
          ],
          userVotingWeight: 1
        }
      ]
    }
  },
  methods: {
    navigateToCreateProposal() {
    // Use Vue Router to programmatically navigate
    this.$router.push('/create-proposal')
  },
    getStatusClasses(status) {
      const statusMap = {
        'ongoing': 'status-ongoing',
        'ended': 'status-ended',
        'approved': 'status-approved',
        'rejected': 'status-rejected'
      }
      return statusMap[status] || 'status-ended'
    },
    totalVotes(proposal) {
      return proposal.options.reduce((sum, option) => sum + option.votes, 0)
    },
    vote(proposalId, optionId) {
      const proposal = this.proposals.find(p => p.id === proposalId)
      const option = proposal.options.find(o => o.id === optionId)

      if (proposal.status !== 'ongoing') {
        alert('This proposal has ended and cannot be voted on.')
        return
      }

      option.votes += proposal.userVotingWeight
      this.saveProposals()
    },
    showProposalDetails(proposalId) {
      const proposal = this.proposals.find(p => p.id === proposalId)
      alert(`Proposal: ${proposal.title}\nDescription: ${proposal.description}\nCreation Date: ${proposal.creationDate}\nDeadline: ${proposal.deadline}`)
    },
    showOptionDetails(optionId) {
      let optionDetails
      this.proposals.forEach(proposal => {
        const option = proposal.options.find(o => o.id === optionId)
        if (option) optionDetails = option.details
      })
      alert(optionDetails)
    },
    capitalizeFirstLetter(string) {
      return string.charAt(0).toUpperCase() + string.slice(1)
    },
    simulateVoting() {
      const randomProposal = this.proposals[Math.floor(Math.random() * this.proposals.length)]
      const randomOption = randomProposal.options[Math.floor(Math.random() * randomProposal.options.length)]

      randomOption.votes += Math.floor(Math.random() * 5)

      if (this.totalVotes(randomProposal) > 200 && randomProposal.status === 'ongoing') {
        randomProposal.status = 'ended'

        const approvedOption = randomProposal.options.reduce((prev, current) => 
          prev.votes > current.votes ? prev : current
        )

        randomProposal.status = approvedOption.name === 'Stocks' ? 'approved' : 'rejected'
      }

      this.saveProposals()
    },
    saveProposals() {
      localStorage.setItem('proposals', JSON.stringify(this.proposals))
    },
    initProposals() {
      const storedProposals = JSON.parse(localStorage.getItem('proposals') || '[]')
      this.proposals = storedProposals.length > 0 ? storedProposals : this.initialProposals
      this.saveProposals()
    }
  },
  mounted() {
    this.initProposals()
    setInterval(this.simulateVoting, 5000)
  }
}
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.governance-platform {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  line-height: 1.6;
  background-color: #f4f4f4;
  color: #333;
}

.header {
  background: linear-gradient(to right, #4f46e5, #7c3aed);
  color: white;
  text-align: center;
  padding: 1.5rem;
}

.header h1 {
  font-size: 2.25rem;
  font-weight: 800;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.dashboard-title h2 {
  font-size: 1.5rem;
  color: #1f2937;
  margin-bottom: 0.5rem;
}

.dashboard-title p {
  color: #6b7280;
}

.create-btn {
  display: inline-flex;
  align-items: center;
  padding: 0.5rem 1rem;
  background-color: #4f46e5;
  color: white;
  border: none;
  border-radius: 0.375rem;
  cursor: pointer;
  transition: background-color 0.2s;
}

.create-btn:hover {
  background-color: #5b21b6;
}

.proposals-table {
  width: 100%;
  background-color: white;
  border-radius: 0.5rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.proposals-table thead {
  background-color: #f9fafb;
}

.proposals-table th,
.proposals-table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
}

.proposal-title {
  color: #4f46e5;
  font-weight: 600;
  cursor: pointer;
}

.proposal-status {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: 9999px;
  font-size: 0.75rem;
}

.status-ongoing { background-color: #ecfccb; color: #3f6212; }
.status-ended { background-color: #f3f4f6; color: #4b5563; }
.status-approved { background-color: #dbeafe; color: #1e40af; }
.status-rejected { background-color: #fee2e2; color: #991b1b; }

.vote-progress {
  width: 100%;
  background-color: #e5e7eb;
  border-radius: 9999px;
  height: 0.625rem;
  margin-top: 0.25rem;
}

.vote-progress-bar {
  height: 100%;
  border-radius: 9999px;
}

.vote-btn {
  background: none;
  border: none;
  color: #4f46e5;
  cursor: pointer;
  transition: color 0.2s;
}

.vote-btn:hover {
  color: #5b21b6;
}

.vote-btn:disabled {
  color: #9ca3af;
  cursor: not-allowed;
}

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #4f46e5;
  color: white;
  padding: 1rem 2rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.navbar-brand .navbar-logo {
  color: white;
  font-size: 1.25rem;
  font-weight: bold;
  text-decoration: none;
}

.navbar-menu {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.navbar-item {
  color: rgba(255,255,255,0.8);
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
  transition: background-color 0.2s, color 0.2s;
}

.navbar-item:hover {
  background-color: rgba(255,255,255,0.1);
  color: white;
}

.navbar-item.active {
  background-color: rgba(255,255,255,0.2);
  color: white;
}
</style>