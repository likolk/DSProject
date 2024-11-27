<template>
    <div class="user-profile">
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
          <router-link to="/create-proposal" class="navbar-item">
            Create Proposal
          </router-link>
          <a href="#" class="navbar-item active">
            Profile
          </a>
          <a href="#" class="navbar-item" @click="handleLogout">
            Logout
          </a>
        </div>
      </nav>
  
      <div class="profile-container">
        <h1>User Profile</h1>
        <div class="profile-header">
          <div class="avatar-container">
            <div class="avatar">
              <span>{{ userProfile.name.charAt(0) }}</span>
            </div>
          </div>
          <div class="user-info">
            <h2>{{ userProfile.name }}</h2>
            <p class="email">{{ userProfile.email }}</p>
            <button @click="toggleEditMode" class="edit-btn">
              {{ isEditing ? 'Save Changes' : 'Edit Profile' }}
            </button>
          </div>
        </div>
  
        <div v-if="isEditing" class="profile-edit-form">
          <div class="form-group">
            <label for="username">Username</label>
            <input
              v-model="userProfile.name"
              type="text"
              id="username"
              placeholder="Enter your username"
            />
          </div>
          <div class="form-group">
            <label for="bio">Bio</label>
            <textarea
              v-model="userProfile.bio"
              id="bio"
              placeholder="Write something about yourself"
            ></textarea>
          </div>
        </div>
  
        <div v-else class="profile-details">
          <h3>Bio</h3>
          <p>{{ userProfile.bio || 'No bio added' }}</p>
        </div>
  
        <div class="profile-section">
          <h3>Proposals You've Proposed</h3>
          <ul class="proposal-list">
            <li v-for="(proposal, index) in userProposals" :key="index">
              <span>{{ proposal.title }}</span> 
              <span class="status" :class="proposal.status">{{ proposal.status }}</span>
            </li>
          </ul>
        </div>
  
        <div class="profile-section">
          <h3>Stocks Owned</h3>
          <ul class="stocks-list">
            <li v-for="(stock, index) in userStocks" :key="index">
              <span>{{ stock.name }} - </span>
              <span class="amount">{{ stock.amount }} shares</span>
            </li>
          </ul>
        </div>
  
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        isEditing: false,
        userProfile: {
          name: 'Kelvin Likollari',
          email: 'kelvin@likollari.ch',
          avatarUrl: '',
          bio: 'This is a short bio about Kelvin Likollari.',
        },
        userProposals: [
          { title: 'Proposal 1', status: 'Ongoing' },
          { title: 'Proposal 2', status: 'Completed' },
        ],
        userStocks: [
          { name: 'Stock A', amount: 100 },
          { name: 'Stock B', amount: 50 },
        ],
      };
    },
    methods: {
      toggleEditMode() {
        if (this.isEditing) {
          // Simulate saving profile changes
          localStorage.setItem('userProfile', JSON.stringify(this.userProfile));
        }
        this.isEditing = !this.isEditing;
      },
      handleLogout() {
        alert('Logging out...');
        // Add actual logout functionality here
      },
    },
    mounted() {
      // Load user profile from localStorage or API if needed
      const storedProfile = JSON.parse(localStorage.getItem('userProfile'));
      if (storedProfile) {
        this.userProfile = storedProfile;
      }
    },
  };
  </script>
  
  <style scoped>
  .user-profile {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    background-color: #f9fafb;
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
  
  .profile-container {
    flex-grow: 1;
    max-width: 900px;
    margin: 2rem auto;
    padding: 3rem;
    background-color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 0.5rem;
  }
  
  .profile-header {
    display: flex;
    align-items: center;
    gap: 2rem;
    margin-bottom: 2rem;
  }
  
  .avatar-container {
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: #4f46e5;
    color: white;
    font-size: 2rem;
    display: flex;
    justify-content: center;
    align-items: center;
    text-transform: uppercase;
  }
  
  .user-info {
    flex-grow: 1;
  }
  
  .user-info h2 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: bold;
  }
  
  .user-info .email {
    color: rgba(0, 0, 0, 0.7);
    margin: 0.5rem 0;
  }
  
  .edit-btn {
    background-color: #4f46e5;
    color: white;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 0.375rem;
    cursor: pointer;
  }
  
  .profile-edit-form {
    margin-top: 2rem;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: bold;
  }
  
  input,
  textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 0.375rem;
  }
  
  textarea {
    min-height: 150px;
  }
  
  .profile-details h3 {
    font-size: 1.25rem;
    margin-bottom: 1rem;
  }
  
  .profile-details p {
    color: rgba(0, 0, 0, 0.7);
  }
  
  .profile-section {
    margin-top: 3rem;
  }
  
  .proposal-list,
  .stocks-list {
    list-style-type: none;
    padding: 0;
  }
  
  .proposal-list li,
  .stocks-list li {
    display: flex;
    justify-content: space-between;
    padding: 0.75rem;
    border-bottom: 1px solid #d1d5db;
  }
  
  .status {
    font-weight: bold;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
  }
  
  .status.Ongoing {
    background-color: #10b981;
    color: white;
  }
  
  .status.Completed {
    background-color: #4f46e5;
    color: white;
  }
  
  .amount {
    font-weight: bold;
    color: #4f46e5;
  }
  </style>
  