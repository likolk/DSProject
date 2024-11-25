const express = require('express');
const { 
    registerVoterController, 
    getProposalVotesController,
    createProposalController,
    listAllProposalsController,
    updateSharesController,
    endVotingController,
    getTotalShares,
    getRewardBalanceController

} = require('../controllers/votingControllers');
const { route } = require('../app');

const router = express.Router();

// Routes
router.get('/shares/total', getTotalShares);
router.get('/proposals', listAllProposalsController);
router.get('/proposal/:proposalId/votes', getProposalVotesController);
router.get('/voter/:address/reward', getRewardBalanceController);

router.post('/voter/register', registerVoterController);
router.post('/proposal', createProposalController);
router.post('/proposal/:proposalId/end', endVotingController);
router.post('/shares/update', updateSharesController);

module.exports = router;
