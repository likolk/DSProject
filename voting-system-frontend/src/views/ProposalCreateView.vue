<template>
  <div class="governance-app">
    <nav class="navbar">
      <div class="navbar-brand">
        <router-link to="/" class="navbar-logo">
          Governance Platform
        </router-link>
      </div>
      <div class="navbar-menu">
        <router-link to="/" class="navbar-item">
          Dashboard
        </router-link>
        <router-link to="/create-proposal" class="navbar-item active">
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

    <div class="create-proposal-container">
      <h1 class="title">Create a New Proposal</h1>
      <form @submit.prevent="submitProposal" class="proposal-form">
        <div class="form-group">
          <label for="title">Proposal Title</label>
          <input
            type="text"
            id="title"
            v-model="proposalTitle"
            required
            placeholder="Enter proposal title"
            class="input"
          />
        </div>

        <div class="form-group">
          <label for="description">Description</label>
          <textarea
            id="description"
            v-model="proposalDescription"
            required
            placeholder="Describe your proposal in detail"
            class="textarea"
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
              class="input"
            />
            <button
              type="button"
              @click="removeOption(index)"
              v-if="votingOptions.length > 2"
              class="remove-option-btn"
            >
              ✖
            </button>
          </div>
          <button
            type="button"
            @click="addOption"
            class="add-option-btn"
          >
            Add Option +
          </button>
        </div>

        <div class="form-group">
          <label for="deadline">Voting Deadline</label>
          <input
            type="date"
            id="deadline"
            v-model="proposalDeadline"
            required
            class="input"
          />
        </div>

        <div class="form-actions">
          <button type="submit" class="submit-btn">Create Proposal</button>
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
  </div>
</template>

<script>
export default {
  data() {
    return {
      proposalTitle: "",
      proposalDescription: "",
      votingOptions: ["", ""],
      proposalDeadline: "",
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
    submitProposal() {
      if (
        !this.proposalTitle ||
        !this.proposalDescription ||
        this.votingOptions.some((opt) => !opt)
      ) {
        alert("Please fill in all fields");
        return;
      }

      const newProposal = {
        id: Date.now(),
        title: this.proposalTitle,
        description: this.proposalDescription,
        status: "ongoing",
        creationDate: new Date().toISOString().split("T")[0],
        deadline: this.proposalDeadline,
        options: this.votingOptions.map((name, index) => ({
          id: index + 1,
          name,
          votes: 0,
          details: "",
        })),
        userVotingWeight: 1,
      };

      const proposals = JSON.parse(localStorage.getItem("proposals") || "[]");
      proposals.push(newProposal);

      localStorage.setItem("proposals", JSON.stringify(proposals));

      this.$router.push("/");
    },
    cancelProposal() {
      this.$router.push("/");
    },
    handleProfile() {
      this.$router.push("/profile");
    },
    handleLogout() {
      alert("Logout functionality not implemented");
    },
  },
};
</script>

<style scoped>
.governance-app {
  font-family: "Roboto", sans-serif;
  background: #002aff;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.navbar {
  background-color: #3b82f6;
  color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.navbar-logo {
  font-size: 1.5rem;
  font-weight: bold;
  text-decoration: none;
  color: #fff;
}

.navbar-menu {
  display: flex;
  gap: 1rem;
}

.navbar-item {
  color: #e0e7ff;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  transition: all 0.3s ease;
  border-radius: 0.5rem;
}

.navbar-item.active,
.navbar-item:hover {
  background-color: #2563eb;
  color: #fff;
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
</style>
