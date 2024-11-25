const express = require('express');
const { 
    registerVoterController, 
    getProposalVotesController,
    createProposalController,
    listAllProposalsController,
    updateSharesController,
    endVotingController

} = require('../controllers/votingControllers');
const { route } = require('../app');

const router = express.Router();

// Routes
router.post('/voter/register', registerVoterController);
router.get('/proposal/:proposalId/votes', getProposalVotesController);
router.post('/proposal', createProposalController);
router.get('/proposals', listAllProposalsController);
router.post('/proposal/:proposalId/end', endVotingController);
router.post('/shares/update', updateSharesController);
module.exports = router;
