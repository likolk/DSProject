// router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import AboutView from '../views/AboutView.vue';
import ProposalCreateView from '../views/ProposalCreateView.vue';
import VotingHistoryView from '../views/VotingHistoryView.vue';

const routes = [
  { path: '/', name: 'Home', component: HomeView },
  { path: '/about', name: 'About', component: AboutView },
  { path: '/create-proposal', name: 'CreateProposal', component: ProposalCreateView },
  { path: '/voting-history', name: 'VotingHistory', component: VotingHistoryView },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
