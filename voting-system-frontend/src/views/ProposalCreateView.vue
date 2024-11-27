<!-- views/ProposalCreateView.vue -->
<template>
  <Layout>
    <template #header>
      <h1 class="text-3xl font-bold tracking-tight text-white">Create New Proposal</h1>
    </template>

    <div class="bg-white p-6 rounded-lg shadow">
      <form @submit.prevent="handleSubmit">
        <div class="mb-4">
          <label class="block text-gray-700">Proposal Title</label>
          <input
            v-model="proposalName"
            type="text"
            class="mt-1 block w-full border border-gray-300 rounded-md p-2"
            required
          />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700">Description</label>
          <textarea
            v-model="description"
            class="mt-1 block w-full border border-gray-300 rounded-md p-2"
            rows="3"
            required
          ></textarea>
        </div>

        <div class="mb-4">
          <label class="block text-gray-700">Options</label>
          <div v-for="(option, index) in options" :key="index" class="border p-4 mb-4">
            <div class="mb-2">
              <label class="block text-gray-700">Option Name</label>
              <input
                v-model="option.name"
                type="text"
                class="mt-1 block w-full border border-gray-300 rounded-md p-2"
                required
              />
            </div>
            <div class="mb-2">
              <label class="block text-gray-700">Option Description</label>
              <textarea
                v-model="option.details"
                class="mt-1 block w-full border border-gray-300 rounded-md p-2"
                rows="2"
              ></textarea>
            </div>
            <button
              type="button"
              @click="removeOption(index)"
              class="text-red-600 hover:text-red-800"
            >
              Remove Option
            </button>
          </div>
          <button
            type="button"
            @click="addOption"
            class="bg-green-500 text-white px-3 py-1 rounded-md hover:bg-green-400"
          >
            Add Option
          </button>
        </div>

        <div class="mb-4">
          <label class="block text-gray-700">Creation Date</label>
          <input
            v-model="creationDate"
            type="date"
            class="mt-1 block w-full border border-gray-300 rounded-md p-2"
            required
          />
        </div>
        <div class="mb-4">
          <label class="block text-gray-700">Deadline</label>
          <input
            v-model="deadline"
            type="date"
            class="mt-1 block w-full border border-gray-300 rounded-md p-2"
            required
          />
        </div>

        <button
          type="submit"
          class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-500"
        >
          Create Proposal
        </button>
      </form>
    </div>
  </Layout>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import Layout from '../components/Layout.vue';

const router = useRouter();

const proposalName = ref('');
const description = ref('');
const options = ref([
  { name: '', details: '' },
]);

const creationDate = ref('');
const deadline = ref('');

const addOption = () => {
  options.value.push({ name: '', details: '' });
};

const removeOption = (index) => {
  options.value.splice(index, 1);
};

const handleSubmit = () => {
  // Validate options
  if (options.value.length < 2) {
    alert('Please provide at least two options.');
    return;
  }

  for (let option of options.value) {
    if (!option.name.trim()) {
      alert('Option names cannot be empty.');
      return;
    }
  }

  // Create new proposal object
  const newProposal = {
    id: Date.now(),
    title: proposalName.value,
    description: description.value,
    status: 'ongoing',
    creationDate: creationDate.value,
    deadline: deadline.value,
    options: options.value.map((option, index) => ({
      id: Date.now() + index,
      name: option.name.trim(),
      votes: 0,
      details: option.details.trim() || 'No details provided.',
    })),
    userVotingWeight: 5,
  };

  // Add new proposal to the proposal list
  const storedProposals = JSON.parse(localStorage.getItem('proposals') || '[]');
  storedProposals.push(newProposal);
  localStorage.setItem('proposals', JSON.stringify(storedProposals));

  alert(`Proposal "${proposalName.value}" has been created!`);

  // Reset form
  proposalName.value = '';
  description.value = '';
  options.value = [{ name: '', details: '' }];
  creationDate.value = '';
  deadline.value = '';

  // Redirect to home page
  router.push('/');
};
</script>
