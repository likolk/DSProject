<template>
  <nav>
    <div class="navbar-menu">
      <router-link to="/" class="navbar-item">
        Dashboard
      </router-link>
      <router-link to="/voting-history" class="navbar-item">
        Voting History
      </router-link>
    </div>
  </nav>

  <div class="governance-app">
    <div class="create-proposal-container">
      <h1 class="title">Create a New Proposal</h1>
      <form @submit.prevent="submitProposal" class="proposal-form">
        <div class="form-group">
          <label for="title">Proposal Title</label>
          <input type="text" id="title" v-model="proposalTitle" required placeholder="Enter proposal title"
            class="input" />
        </div>

        <div class="form-group">
          <label for="description">Description</label>
          <textarea id="description" v-model="proposalDescription" required
            placeholder="Describe your proposal in detail" class="textarea"></textarea>
        </div>

        <div class="form-group">
          <label>Voting Options</label>
          <div v-for="(option, index) in votingOptions" :key="index" class="option-input">
            <input type="text" v-model="votingOptions[index]" placeholder="Enter option" class="input" />
            <button type="button" @click="removeOption(index)" v-if="votingOptions.length > 2"
              class="remove-option-btn">
              ✖
            </button>
          </div>
          <button type="button" @click="addOption" class="add-option-btn">
            Add Option +
          </button>
        </div>

        <div class="form-group">
          <label for="deadline">Voting Deadline</label>
          <input type="date" id="deadline" v-model="proposalDeadline" required class="input" />
        </div>

        <div class="form-actions">
          <button type="submit" class="submit-btn">Create Proposal</button>
          <button type="button" class="cancel-btn" @click="cancelProposal">
            Cancel
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import web3Service from "@/services/web3Service";
export default {

  data() {
    return {
      proposalTitle: "",
      proposalDescription: "",
      votingOptions: ["", ""],
      proposalDeadline: "",
      quorumType: 0,
    };
  },
  methods: {
    addOption() {
      if (this.votingOptions.length < 5) {
        this.votingOptions.push("");
      }
    },
    removeOption(index) {
      if (this.votingOptions.length > 2) {
        this.votingOptions.splice(index, 1);
      }
    },
    async submitProposal() {
      if (
        !this.proposalTitle ||
        !this.proposalDescription ||
        this.votingOptions.some((opt) => !opt)
      ) {
        alert("Please fill in all fields");
        return;
      }

      console.log("Submitting Proposal:", {
        title: this.proposalTitle,
        description: this.proposalDescription,
        deadline: this.proposalDeadline,
        quorumType: this.quorumType
      });
      try {
        await web3Service.createProposal(
          this.proposalTitle,
          this.proposalDescription,
          this.proposalDeadline,
          this.quorumType
        );
        this.$router.push("/");
      } catch (error) {
        console.error('Error during proposal creation:', error);
        alert(`Error creating proposal: ${error.message || error}`);
      }

    },
    cancelProposal() {
      this.$router.push("/");
    },
    handleProfile() {
      this.$router.push("/profile");
    },
  },
};
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.governance-app {
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


.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #4f46e5;
  color: white;
  padding: 1rem 2rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.navbar-menu {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.navbar-item {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
  transition: background-color 0.2s, color 0.2s;
}

.navbar-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.navbar-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.create-proposal-container {
  background: #fff;
  max-width: 700px;
  margin: 2rem auto;
  padding: 2rem 3rem;
  border-radius: 1rem;
  box-shadow: 5px 5px 5px 10px rgb(255, 2, 2);
}

.title {
  font-size: 1.8rem;
  color: #1f2937;
  text-align: center;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

label {
  display: block;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #374151;
}

.input,
.textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  border-radius: 0.5rem;
  transition: border-color 0.3s ease;
  font-size: 1rem;
}

.input:focus,
.textarea:focus {
  outline: none;
  border-color: #3b82f6;
}

.option-input {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
}

.remove-option-btn {
  background: #ef4444;
  color: #fff;
  border: none;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  cursor: pointer;
  font-size: 0.9rem;
}

.add-option-btn {
  background: #10b981;
  color: #fff;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  font-size: 1rem;
}

.form-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2rem;
}

.submit-btn {
  background: #3b82f6;
  color: #fff;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 0.5rem;
  font-size: 1rem;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

.submit-btn:hover {
  background-color: #2563eb;
}

.cancel-btn {
  background: transparent;
  color: #ef4444;
  border: 1px solid #ef4444;
  padding: 0.75rem 2rem;
  border-radius: 0.5rem;
  font-size: 1rem;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.cancel-btn:hover {
  background: #ef4444;
  color: #fff;
}


.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #4f46e5;
  color: white;
  padding: 1rem 2rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
  transition: background-color 0.2s, color 0.2s;
}

.navbar-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.navbar-item.active {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Roboto", sans-serif;
  color: #333;
}
</style>
