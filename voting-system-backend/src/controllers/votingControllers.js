
// Register shareholder, Submit a vote

const { registerVoter, getProposalVotes } = require('../contractService');


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

module.exports = { registerVoterController, getProposalVotesController };
