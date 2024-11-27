<!-- views/VotingHistoryView.vue -->
<template>
  <Layout>
    <template #header>
      <h1 class="text-3xl font-bold tracking-tight text-white">Voting History</h1>
    </template>

    <div class="bg-white p-6 rounded-lg shadow">
      <table class="min-w-full divide-y divide-gray-200">
        <thead>
          <tr>
            <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Voting Time</th>
            <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Proposal Name</th>
            <th class="px-6 py-3 text-left text-sm font-medium text-gray-500">Your Choice</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="(record, index) in votingHistory" :key="index">
            <td class="px-6 py-4 text-sm text-gray-900">{{ record.time }}</td>
            <td class="px-6 py-4 text-sm text-gray-900">{{ record.proposalName }}</td>
            <td class="px-6 py-4 text-sm text-gray-900">{{ record.choice }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </Layout>
</template>

<script setup>
import Layout from '../components/Layout.vue';
import { ref } from 'vue';

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
  // Add more historical records here
]);
</script>
