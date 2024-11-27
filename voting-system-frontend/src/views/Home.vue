<template>
    <div class="home">
      <h1>Decentralized Voting System</h1>
  
      <!-- Shareholder Registration Section -->
      <section class="card">
        <h2>Register as Shareholder</h2>
        <ShareholderRegistration />
      </section>
  
      <!-- Voting Section -->
      <section class="card">
        <h2>Vote on Proposals</h2>
        <VotingComponent />
      </section>
  
      <!-- Proposal Creation Section (Only for shareholders with enough shares) -->
      <section class="card">
        <h2>Create Proposal</h2>
        <ProposalCreation />
      </section>
  
      <!-- Voting History Section -->
      <section class="card">
        <h2>Voting History</h2>
        <VotingHistoryDashboard />
      </section>
  
      <!-- Voting Progress Section -->
      <section class="card">
        <h2>Voting Progress</h2>
        <VotingProgress />
      </section>
    </div>
  </template>
  
  <script>
  import ShareholderRegistration from "@/components/ShareholderRegistration.vue";
  import VotingComponent from "@/components/VotingComponent.vue";
  import ProposalCreation from "@/components/ProposalCreation.vue";
  import VotingHistoryDashboard from "@/components/VotingHistoryDashboard.vue";
  import VotingProgress from "@/components/VotingProgress.vue";
  
  export default {
    name: "Home",
    components: {
      ShareholderRegistration,
      VotingComponent,
      ProposalCreation,
      VotingHistoryDashboard,
      VotingProgress
    }
  };
  </script>
  
  <style scoped>
  /* Main container */
  .home {
    font-family: 'Arial', sans-serif;
    padding: 20px;
    background-color: #f4f7fc;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 40px;
  }
  
  /* Main title */
  h1 {
    text-align: center;
    font-size: 2.5rem;
    color: #333;
    margin-bottom: 40px;
    font-weight: 700;
    letter-spacing: 1px;
  }
  
  /* Section card styles */
  section.card {
    background-color: white;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 800px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  /* Hover effect for card */
  section.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  }
  
  /* Section headings */
  section h2 {
    margin-bottom: 15px;
    font-size: 1.5rem;
    color: #4a90e2;
    font-weight: 600;
  }
  
  /* Button styles */
  section button {
    background-color: #4a90e2;
    color: white;
    border: none;
    border-radius: 5px;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }
  
  section button:hover {
    background-color: #357ab7;
  }
  
  /* Paragraph text */
  section p {
    font-size: 16px;
    color: #555;
  }
  
  /* Responsive Design for smaller screens */
  @media (max-width: 768px) {
    h1 {
      font-size: 2rem;
    }
  
    section h2 {
      font-size: 1.3rem;
    }
  
    section.card {
      width: 90%;
      padding: 15px;
    }
  }
  </style>
  