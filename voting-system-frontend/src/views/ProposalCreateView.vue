<template>
  <div class="create-proposal-container">
    <h1>Create New Proposal</h1>
    <form @submit.prevent="submitProposal">
      <div class="form-group">
        <label for="title">Proposal Title</label>
        <input 
          type="text" 
          id="title" 
          v-model="proposalTitle" 
          required 
          placeholder="Enter proposal title"
        >
      </div>

      <div class="form-group">
        <label for="description">Description</label>
        <textarea 
          id="description" 
          v-model="proposalDescription" 
          required 
          placeholder="Describe your proposal in detail"
        ></textarea>
      </div>

      <div class="form-group">
        <label>Voting Options</label>
        <div 
          v-for="(option, index) in votingOptions" 
          :key="index" 
          class="option-input"
        >
          <input 
            type="text" 
            v-model="votingOptions[index]" 
            placeholder="Enter option"
          >
          <button 
            type="button" 
            @click="removeOption(index)" 
            v-if="votingOptions.length > 2"
          >
            Remove
          </button>
        </div>
        <button 
          type="button" 
          @click="addOption" 
          class="add-option-btn"
        >
          Add Option
        </button>
      </div>

      <div class="form-group">
        <label for="deadline">Voting Deadline</label>
        <input 
          type="date" 
          id="deadline" 
          v-model="proposalDeadline" 
          required
        >
      </div>

      <div class="form-actions">
        <button 
          type="submit" 
          class="submit-btn"
        >
          Create Proposal
        </button>
        <button 
          type="button" 
          class="cancel-btn" 
          @click="cancelProposal"
        >
          Cancel
        </button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      proposalTitle: '',
      proposalDescription: '',
      votingOptions: ['', ''],
      proposalDeadline: ''
    }
  },
  methods: {
    addOption() {
      if (this.votingOptions.length < 5) {
        this.votingOptions.push('')
      }
    },
    removeOption(index) {
      if (this.votingOptions.length > 2) {
        this.votingOptions.splice(index, 1)
      }
    },
    submitProposal() {
      // Validate inputs
      if (!this.proposalTitle || !this.proposalDescription || this.votingOptions.some(opt => !opt)) {
        alert('Please fill all fields')
        return
      }

      // Create proposal object
      const newProposal = {
        id: Date.now(),
        title: this.proposalTitle,
        description: this.proposalDescription,
        status: 'ongoing',
        creationDate: new Date().toISOString().split('T')[0],
        deadline: this.proposalDeadline,
        options: this.votingOptions.map((name, index) => ({
          id: index + 1,
          name,
          votes: 0,
          details: ''
        })),
        userVotingWeight: 1
      }

      // Get existing proposals from localStorage
      const proposals = JSON.parse(localStorage.getItem('proposals') || '[]')
      proposals.push(newProposal)
      
      // Save to localStorage
      localStorage.setItem('proposals', JSON.stringify(proposals))

      // Navigate back to dashboard
      this.$router.push('/')
    },
    cancelProposal() {
      // Navigate back to dashboard
      this.$router.push('/')
    }
  }
}
</script>

<style scoped>
.create-proposal-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
  background-color: white;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  border-radius: 0.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

input, textarea {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
}

textarea {
  min-height: 100px;
}

.option-input {
  display: flex;
  margin-bottom: 0.5rem;
}

.option-input input {
  flex-grow: 1;
  margin-right: 0.5rem;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  margin-top: 1rem;
}

.submit-btn, .cancel-btn {
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  cursor: pointer;
}

.submit-btn {
  background-color: #4f46e5;
  color: white;
  border: none;
}

.cancel-btn {
  background-color: #f3f4f6;
  color: #4b5563;
  border: 1px solid #d1d5db;
}

.add-option-btn {
  margin-top: 0.5rem;
  background-color: #10b981;
  color: white;
  border: none;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
}
</style>