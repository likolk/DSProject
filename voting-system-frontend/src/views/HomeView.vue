<!-- views/HomeView.vue -->
<template>
  <Layout>
    <template #header>
      <h1 class="text-3xl font-bold tracking-tight text-white">Our Dapp</h1>
    </template>

    <div class="px-4 sm:px-6 lg:px-8 pt-6">
      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto">
          <h1 class="text-base font-semibold text-gray-900">Proposal List</h1>
          <p class="mt-2 text-sm text-gray-700">
            A list of all current proposals and their status.
          </p>
        </div>
        <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
          <button
            @click="$router.push('/create-proposal')"
            type="button"
            class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500"
          >
            Create Proposal
          </button>
        </div>
      </div>

      <div class="mt-8 flow-root">
        <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
                <tr>
                  <th
                    class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
                  >
                    Proposal
                  </th>
                  <th
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Options
                  </th>
                  <th
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Voting Results
                  </th>
                  <th
                    class="relative py-3.5 pl-3 pr-4 sm:pr-0"
                  >
                    <span class="sr-only">Vote</span>
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200 bg-white">
                <tr v-for="proposal in proposals" :key="proposal.id">
                  <td
                    class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0"
                  >
                    <div class="text-gray-900 font-medium flex items-center">
                      <button
                        @click="showProposalDetails(proposal)"
                        class="text-left text-blue-600 hover:text-blue-900 underline"
                      >
                        {{ proposal.title }}
                      </button>
                      <span
                        class="ml-2 inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium"
                        :class="statusClasses(proposal.status)"
                      >
                        {{ statusText(proposal.status) }}
                      </span>
                    </div>
                    <div class="mt-1 text-gray-500">
                      {{ proposal.description }}
                    </div>
                  </td>
                  <td
                    class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"
                  >
                    <ul>
                      <li
                        v-for="option in proposal.options"
                        :key="option.id"
                        class="mb-2"
                      >
                        <button
                          @click="showOptionDetails(option)"
                          class="text-blue-600 hover:text-blue-900 underline"
                        >
                          {{ option.name }}
                        </button>
                      </li>
                    </ul>
                  </td>
                  <td
                    class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"
                  >
                    <ul>
                      <li
                        v-for="option in proposal.options"
                        :key="option.id"
                        class="mb-4"
                      >
                        {{ option.votes }} votes
                        <div class="w-full bg-gray-200 rounded-full h-2.5 mt-1">
                          <div
                            class="bg-blue-600 h-2.5 rounded-full"
                            :style="{
                              width:
                                (option.votes / totalVotes(proposal)) * 100 +
                                '%',
                            }"
                          ></div>
                        </div>
                      </li>
                    </ul>
                  </td>
                  <td
                    class="relative whitespace-nowrap py-5 pl-3 pr-4 text-right text-sm font-medium sm:pr-0"
                  >
                    <ul>
                      <li
                        v-for="option in proposal.options"
                        :key="option.id"
                        class="mb-2"
                      >
                        <button
                          @click="vote(proposal, option)"
                          class="text-indigo-600 hover:text-indigo-900"
                          :disabled="proposal.status !== 'ongoing'"
                        >
                          Vote
                        </button>
                      </li>
                    </ul>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Option Details Modal -->
      <div v-if="isOptionModalOpen" class="fixed z-10 inset-0 overflow-y-auto">
        <div
          class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0"
        >
          <div
            class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
            aria-hidden="true"
          ></div>

          <!-- This element is to trick the browser into centering the modal contents. -->
          <span
            class="hidden sm:inline-block sm:align-middle sm:h-screen"
            aria-hidden="true"
            >&#8203;</span
          >

          <div
            class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
            role="dialog"
            aria-modal="true"
            aria-labelledby="modal-headline"
          >
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <h3
                class="text-lg leading-6 font-medium text-gray-900"
                id="modal-headline"
              >
                {{ selectedOption.name }}
              </h3>
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  {{ selectedOption.details }}
                </p>
              </div>
            </div>
            <div
              class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse"
            >
              <button
                @click="isOptionModalOpen = false"
                type="button"
                class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Proposal Details Modal -->
      <div v-if="isProposalModalOpen" class="fixed z-10 inset-0 overflow-y-auto">
        <div
          class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0"
        >
          <div
            class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
            aria-hidden="true"
          ></div>

          <!-- This element is to trick the browser into centering the modal contents. -->
          <span
            class="hidden sm:inline-block sm:align-middle sm:h-screen"
            aria-hidden="true"
            >&#8203;</span
          >

          <div
            class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
            role="dialog"
            aria-modal="true"
            aria-labelledby="proposal-modal-headline"
          >
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <h3
                class="text-lg leading-6 font-medium text-gray-900"
                id="proposal-modal-headline"
              >
                {{ selectedProposal.title }}
              </h3>
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  {{ selectedProposal.description }}
                </p>
                <p class="mt-2 text-sm text-gray-500">
                  <strong>Creation Date:</strong> {{ selectedProposal.creationDate }}
                </p>
                <p class="mt-1 text-sm text-gray-500">
                  <strong>Deadline:</strong> {{ selectedProposal.deadline }}
                </p>
              </div>
            </div>
            <div
              class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse"
            >
              <button
                @click="isProposalModalOpen = false"
                type="button"
                class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
import Layout from '../components/Layout.vue';

const router = useRouter();

const proposals = ref([]);

// Initial proposal data
const initialProposals = [
  {
    id: 1,
    title: 'Investment Strategy Selection',
    description: 'Please choose the investment portfolio you think is most suitable.',
    status: 'ongoing',
    creationDate: '2023-09-01',
    deadline: '2023-09-30',
    options: [
      {
        id: 1,
        name: 'Stocks',
        votes: 50,
        details: 'Stocks are securities representing ownership in a company.',
      },
      {
        id: 2,
        name: 'Bonds',
        votes: 30,
        details: 'Bonds are debt securities issued by companies or governments.',
      },
      {
        id: 3,
        name: 'Mixed Funds',
        votes: 20,
        details: 'Mixed funds invest in a combination of stocks and bonds.',
      },
    ],
    userVotingWeight: 5, // User's voting weight
  },
  {
    id: 2,
    title: 'Company Strategy Adjustment',
    description: 'Please choose the future development direction of the company.',
    status: 'ongoing',
    creationDate: '2023-08-15',
    deadline: '2023-09-15',
    options: [
      {
        id: 4,
        name: 'Expand Overseas Markets',
        votes: 40,
        details: 'Expanding overseas markets helps the company globalize.',
      },
      {
        id: 5,
        name: 'Focus on Domestic Business',
        votes: 60,
        details: 'Focusing on domestic business can consolidate the existing market.',
      },
    ],
    userVotingWeight: 1,
  },
  // You can continue to add more proposals
];

const isOptionModalOpen = ref(false);
const selectedOption = ref({});

const isProposalModalOpen = ref(false);
const selectedProposal = ref({});

const showOptionDetails = (option) => {
  selectedOption.value = option;
  isOptionModalOpen.value = true;
};

const showProposalDetails = (proposal) => {
  selectedProposal.value = proposal;
  isProposalModalOpen.value = true;
};

const vote = (proposal, option) => {
  if (proposal.status !== 'ongoing') {
    alert('This proposal has ended and cannot be voted on.');
    return;
  }

  // Increase the vote count of the option
  option.votes += proposal.userVotingWeight;

  // Update the proposals data in localStorage
  localStorage.setItem('proposals', JSON.stringify(proposals.value));
};

const totalVotes = (proposal) => {
  return proposal.options.reduce((sum, option) => sum + option.votes, 0);
};

const statusClasses = (status) => {
  switch (status) {
    case 'ongoing':
      return 'bg-green-100 text-green-800';
    case 'ended':
      return 'bg-gray-100 text-gray-800';
    case 'approved':
      return 'bg-blue-100 text-blue-800';
    case 'rejected':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
};

const statusText = (status) => {
  switch (status) {
    case 'ongoing':
      return 'Ongoing';
    case 'ended':
      return 'Ended';
    case 'approved':
      return 'Approved';
    case 'rejected':
      return 'Rejected';
    default:
      return 'Unknown Status';
  }
};

let intervalId;

onMounted(() => {
  const storedProposals = JSON.parse(localStorage.getItem('proposals') || '[]');
  if (storedProposals.length > 0) {
    proposals.value = storedProposals;
  } else {
    proposals.value = initialProposals;
    localStorage.setItem('proposals', JSON.stringify(initialProposals));
  }

  intervalId = setInterval(() => {
    // Simulate other users voting
    const randomProposal = proposals.value[Math.floor(Math.random() * proposals.value.length)];
    const randomOption = randomProposal.options[Math.floor(Math.random() * randomProposal.options.length)];

    // Increase random votes
    randomOption.votes += Math.floor(Math.random() * 5);

    // Update proposal status
    if (totalVotes(randomProposal) > 200 && randomProposal.status === 'ongoing') {
      randomProposal.status = 'ended';

      // Decide approval or rejection based on voting results
      const approvedOption = randomProposal.options.reduce((prev, current) => (prev.votes > current.votes ? prev : current));
      if (approvedOption.name === 'Stocks') {
        randomProposal.status = 'approved';
      } else {
        randomProposal.status = 'rejected';
      }
    }

    // Update the proposals data in localStorage
    localStorage.setItem('proposals', JSON.stringify(proposals.value));
  }, 5000); // Simulate every 5 seconds
});

onBeforeUnmount(() => {
  clearInterval(intervalId);
});
</script>