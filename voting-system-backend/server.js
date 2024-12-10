const express = require("express");
const { registerVoterController, getProposalVotesController } = require('./src/controllers/votingControllers');
const dotenv = require('dotenv');
dotenv.config();

const PORT = process.env.PORT || 5000;
const app = express();

app.use(express.json());

app.post("/registerVoter", registerVoterController);
app.get("/proposal/:proposalId/votes", getProposalVotesController);

app.listen(PORT, () => console.log(`Backend running on http://localhost:${PORT}`));
