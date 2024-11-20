import { createRouter, createWebHistory } from 'vue-router';
import VoterRegistration from '../components/VoterRegistration.vue';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: VoterRegistration, // Setting VoterRegistration as the default dummy page
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
