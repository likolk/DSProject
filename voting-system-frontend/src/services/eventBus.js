// src/services/eventBus.js

import { reactive } from 'vue';

export const eventBus = reactive({
  emit(event, ...args) {
    const handlers = this[event] || [];
    handlers.forEach(handler => handler(...args));
  },
  on(event, handler) {
    if (!this[event]) {
      this[event] = [];
    }
    this[event].push(handler);
  },
  off(event, handler) {
    if (this[event]) {
      const index = this[event].indexOf(handler);
      if (index > -1) {
        this[event].splice(index, 1);
      }
    }
  }
});
