const express = require('express');
const { registerShareholder, vote } = require('.././controllers/votingControllers');

const router = express.Router();

// Endpoints    
// router.post('/register', registerShareholder);
// router.post('/vote', vote);

module.exports = router;
