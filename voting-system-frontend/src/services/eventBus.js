// src/services/eventBus.js
import mitt from 'mitt';

// Create the event bus using mitt
const eventBus = mitt();

export { eventBus };
