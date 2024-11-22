<template>
  <div>
    <h2>Register as a Voter</h2>
    <form @submit.prevent="register">
      <label for="address">Ethereum Address:</label>
      <input v-model="address" type="text" id="address" required />
      <label for="shares">Shares:</label>
      <input v-model="shares" type="number" id="shares" required />
      <button type="submit">Register</button>
    </form>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      address: "",
      shares: "",
    };
  },
  methods: {
    async register() {
      try {
        await axios.post("http://localhost:8000/registerVoter", {
          address: this.address,
          shares: this.shares,
        });
        alert("Voter registered successfully!");
      } catch (error) {
        console.error("Error registering voter:", error);
      }
    },
  },
};
</script>
