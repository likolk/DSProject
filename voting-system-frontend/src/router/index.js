// router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import ProposalCreateView from '../views/ProposalCreateView.vue';
import VotingHistoryView from '../views/VotingHistoryView.vue';
import UserProfile from '@/views/UserProfile.vue';
// import ShareholderRegistration from '@/views/ShareholderRegistration.vue';

const routes = [
  { 
    path: '/', 
    name: 'Home', 
    component: HomeView 
  },

  { 
    path: '/create-proposal', 
    name: 'CreateProposal', 
    component: ProposalCreateView 
  },

  { 
    path: '/voting-history', 
    name: 'VotingHistory', 
    component: VotingHistoryView 
  },

  {
    path: '/profile',
    name: 'Profile',
    component: UserProfile
  },

  // {
  //   path: '/register',
  //   name: 'Register',
  //   component: ShareholderRegistration
  // }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
