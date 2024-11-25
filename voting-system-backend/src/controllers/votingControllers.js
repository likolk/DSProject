
// Register shareholder, Submit a vote

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
  const {description} = req.body;
  try {
    const txHash = await createProposal(description);
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



module.exports = { 
  registerVoterController, 
  getProposalVotesController,
  listAllProposalsController,
  createProposalController
 };
