
// Register shareholder, Submit a vote

const contractService = require('../contractService');
const {registerVoter, getProposalVotes, listAllProposals, createProposal } = require('../contractService');


async function registerVoterController(req, res) {
  const { address, shares } = req.body;

  try {
    const txHash = await registerVoter(address, shares);
    res.status(200).json({ message: "Voter registered succesfully", txHash });
  } catch (error) {
    console.error("Error registering voter:", error);
    res.status(500).json({ error: "Failed to register voter" });
  }
}
async function getProposalVotesController(req, res) {
  const { proposalId } = req.params;

  try {
    const votes = await getProposalVotes(proposalId);
    res.status(200).json({ proposalId, votes });
  } catch (error) {
    console.error("Error fetching proposal votes:", error);
    res.status(500).json({ error: "Failed to fetch votes" });
  }
}

async function createProposalController(req, res) {
  const {description, durationInMinutes} = req.body;
  try {
    const txHash = await createProposal(description, durationInMinutes);
    res.status(201).json({
      message:"Successfully created proposl", txHash
    })
  } catch(error) {
    console.error("Error while creating porposal", error);
    res.status(500).json({
      error: "Failure creating proposal"
    })
  }
}

async function listAllProposalsController(req, res) {
  try {
    const proposals = await listAllProposals();
    res.status(200).json(proposals);
  } catch(error) {
    console.error("Erroe while fetching proposals");
    res.status(500).json({
      error: "error retrieving proposals"
    })
  }
}

async function  endVotingController(req, res) {
  const {proposalId} = req.params;
  try {
    const txHash = await endVoting(proposalId);
    res.status(200).json({
      message: "Voting is over", txHash
    });
  } catch(error) {
    console.log("error while ending voting");
    res.status(500).json({
      error: "error while failing voting"
    })
  }
}

async function  updateSharesController(req, res) {
  const {address, newShares} = req.body;
  try {
    const txHash = await updateSharesController(address, newShares);
    res.status(200).json({
      message: "Shares updated successfully", txHash
    });
  } catch (error) {
    console.error("Error updating shares:", error);
    res.status(500).json({ error: "Failure updating shares" });
  }
}

async function getTotalShares(req, res) {
  try {
    const totalShares = await getTotalShares();
    res.status(200).json({
      totalShares
    });
  } catch(error) {
    console.log("Eror while fetchign total shares", error);
    res.status(500).json({
      error: "Failed whiel fetching total number of sahres."
    })
  }
}

async function getRewardBalanceController(req, res) {
  const {address} = req.params;
  try {
    const balance = await getRewardBalance(address);
    res.stats(200).json({
      address, balance
    });
  } catch(error){
    console.error("Error while fethcing reward balance:", error);
    res.status(500).json({ error: "Failed to retireve reward balance" });
  }
}

async function getVotingProgressController(req, res) {
  const {proposalId} = req.params;
  try {
    const progress = await getVotingProgressController(proposalId);
    res.status(200).json({
      proposalId,
      progress: progress[0],
      quorum: progress[1]
    })
  }catch (error) {
    console.error("Error fetching voting progress:", error);
    res.status(500).json({ error: "Failed to fetch voting progress" });
  }
}

async function checkQuorum(req, res) {
  const {proposalId} = req.params;
  try {
    const quorumMet = await contractService.checkQuorum(proposalId);
    res.status(200).json({
      success: true,
      quorumMet: quorumMet,
      message: quorumMet ? "Quorum Has Been Met. Voting Ending" : "Quorum not yet met"
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
      message: "An error occurred while checking voting quorum."
    });
  }
}

async function deleteProposalController(req, res) {
  const { proposalId } = req.params;
  try {
      const txHash = await contractService.deleteProposal(proposalId);
      res.status(200).json({
          message: "Proposal deleted successfully", txHash
      });
  } catch (error) {
      console.error("Error deleting proposal:", error);
      res.status(500).json({ error: "Failed to delete proposal" });
  }
}

module.exports = { 
  registerVoterController, 
  getProposalVotesController,
  listAllProposalsController,
  createProposalController,
  updateSharesController,
  endVotingController,
  getTotalShares,
  getRewardBalanceController,
  getVotingProgressController,
  checkQuorum,
  deleteProposalController
 };
