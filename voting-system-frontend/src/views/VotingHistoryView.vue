<!-- views/VotingHistoryView.vue -->
<template>
  <div class="voting-history-container">
    <div class="header-gradient">
      <div class="header-content">
        <h1 class="text-4xl font-extrabold text-white tracking-tight">
          <span class="text-indigo-200">Your</span> Voting History
        </h1>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ votingHistory.length }}</span>
            <span class="stat-label">Total Votes</span>
          </div>
          <div class="stat-item">
            <span class="stat-number">{{ agreementRate }}%</span>
            <span class="stat-label">Agreement Rate</span>
          </div>
        </div>
      </div>
    </div>

    <nav class="navbar">
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

    <div class="voting-history-content">
      <div class="search-and-filter">
        <input 
          v-model="searchQuery" 
          placeholder="Search proposals..." 
          class="search-input"
        >
        <div class="filter-dropdown">
          <select v-model="selectedFilter" class="filter-select">
            <option value="">All Choices</option>
            <option value="Agree">Agree</option>
            <option value="Disagree">Disagree</option>
            <option value="Abstain">Abstain</option>
          </select>
        </div>
      </div>

      <div class="voting-table-wrapper">
        <table class="voting-table">
          <thead>
            <tr>
              <th @click="sortBy('time')">
                Voting Time
                <span class="sort-icon">
                  {{ sortColumn === 'time' ? (sortDirection === 'asc' ? '▲' : '▼') : '' }}
                </span>
              </th>
              <th @click="sortBy('proposalName')">
                Proposal Name
                <span class="sort-icon">
                  {{ sortColumn === 'proposalName' ? (sortDirection === 'asc' ? '▲' : '▼') : '' }}
                </span>
              </th>
              <th @click="sortBy('choice')">
                Your Choice
                <span class="sort-icon">
                  {{ sortColumn === 'choice' ? (sortDirection === 'asc' ? '▲' : '▼') : '' }}
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(record, index) in filteredAndSortedHistory" 
              :key="index"
              :class="{
                'choice-agree': record.choice === 'Agree',
                'choice-disagree': record.choice === 'Disagree',
                'choice-abstain': record.choice === 'Abstain'
              }"
            >
              <td>{{ formatDateTime(record.time) }}</td>
              <td>{{ record.proposalName }}</td>
              <td>{{ record.choice }}</td>
            </tr>
          </tbody>
        </table>
        
        <div v-if="filteredAndSortedHistory.length === 0" class="no-results">
          No voting history found
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const votingHistory = ref([
  {
    time: '2023-10-01 12:30',
    proposalName: 'Increase Development Team Size',
    choice: 'Agree',
  },
  {
    time: '2023-09-28 09:15',
    proposalName: 'Adjust Working Hours',
    choice: 'Disagree',
  },
  {
    time: '2023-09-15 14:45',
    proposalName: 'New Office Location',
    choice: 'Abstain',
  },
]);

// Search and filtering
const searchQuery = ref('');
const selectedFilter = ref('');
const sortColumn = ref('time');
const sortDirection = ref('desc');

// Computed properties
const filteredAndSortedHistory = computed(() => {
  let result = votingHistory.value.filter(record => {
    const matchesSearch = record.proposalName.toLowerCase().includes(searchQuery.value.toLowerCase());
    const matchesFilter = !selectedFilter.value || record.choice === selectedFilter.value;
    return matchesSearch && matchesFilter;
  });

  return result.sort((a, b) => {
    let modifier = sortDirection.value === 'asc' ? 1 : -1;
    if (a[sortColumn.value] < b[sortColumn.value]) return -1 * modifier;
    if (a[sortColumn.value] > b[sortColumn.value]) return 1 * modifier;
    return 0;
  });
});

// Calculate agreement rate
const agreementRate = computed(() => {
  const agreeCount = votingHistory.value.filter(record => record.choice === 'Agree').length;
  return Math.round((agreeCount / votingHistory.value.length) * 100);
});

// Methods
const sortBy = (column) => {
  if (sortColumn.value === column) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc';
  } else {
    sortColumn.value = column;
    sortDirection.value = 'desc';
  }
};

const formatDateTime = (dateTime) => {
  const date = new Date(dateTime);
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

// Navigation methods
const handleProfile = () => {
  alert('Profile functionality not implemented');
};

const handleLogout = () => {
  alert('Logout functionality not implemented');
};
</script>

<style scoped>
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

/* Voting History Container Styles */
.voting-history-container {
  background-color: #f9fafb;
  min-height: 100vh;
}

.header-gradient {
  background: linear-gradient(to right, #4337CA, #7E3AF2);
  color: white;
  padding: 3rem 1.5rem;
}

.header-content {
  max-width: 80rem;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-stats {
  display: flex;
  gap: 1.5rem;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-number {
  font-size: 2.25rem;
  font-weight: bold;
  color: white;
}

.stat-label {
  font-size: 0.875rem;
  color: rgba(255,255,255,0.7);
}

.voting-history-content {
  max-width: 80rem;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

.search-and-filter {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1.5rem;
}

.search-input {
  width: 66%;
  padding: 0.5rem 1rem;
  border: 1px solid #D1D5DB;
  border-radius: 0.5rem;
  transition: all 0.2s ease;
}

.search-input:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.5);
}

.filter-select {
  padding: 0.5rem 1rem;
  border: 1px solid #D1D5DB;
  border-radius: 0.5rem;
  transition: all 0.2s ease;
}

.filter-select:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.5);
}

.voting-table-wrapper {
  background-color: white;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  border-radius: 0.75rem;
  overflow: hidden;
}

.voting-table {
  width: 100%;
}

.voting-table thead {
  background-color: #F9FAFB;
}

.voting-table th {
  padding: 0.75rem 1.5rem;
  text-align: left;
  font-size: 0.75rem;
  font-weight: 500;
  color: #6B7280;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  cursor: pointer;
  transition: background-color 0.2s;
}

.voting-table th:hover {
  background-color: #F3F4F6;
}

.voting-table tbody tr:hover {
  background-color: #F9FAFB;
}

.voting-table td {
  padding: 1rem 1.5rem;
  white-space: nowrap;
  font-size: 0.875rem;
  color: #111827;
}

.choice-agree {
  background-color: #ECFDF5;
}

.choice-disagree {
  background-color: #FEF3F2;
}

.choice-abstain {
  background-color: #FFFBEA;
}

.no-results {
  text-align: center;
  color: #6B7280;
  padding: 1.5rem 0;
  font-size: 1.125rem;
}

.sort-icon {
  margin-left: 0.5rem;
  font-size: 0.75rem;
}
</style>