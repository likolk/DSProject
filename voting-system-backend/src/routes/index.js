const express = require('express');
const { registerVoterController, getProposalVotesController } = require('../controllers/votingControllers');

const router = express.Router();

// Routes
router.post('/voter/register', registerVoterController);
router.get('/proposal/:proposalId/votes', getProposalVotesController);

module.exports = router;
