const express = require("express");
const Web3 = require('web3').default;
const contractABI = require("./src/contractService").abi;
const dotenv = require('dotenv')
dotenv.config();
const PORT = process.env.PORT || 5000;

const app = express();
app.use(express.json());

// connecting to ganache
const web3 = new Web3("http://127.0.0.1:8545");

// Smart Contract
const contractAddress = "0x00BfAc1357103a794a51CbEB561B0f9126D2641b";
const contract = new web3.eth.Contract(contractABI, contractAddress);

app.post("/registerVoter", async (req, res) => {
  try {
    const { address, shares } = req.body;
    const accounts = await web3.eth.getAccounts();
    await contract.methods.registerVoter(address, shares).send({ from: accounts[0] });
    res.status(200).send("Voter registered successfully.");
  } catch (error) {
    res.status(500).send("Error registering voter: " + error.message);
  }
});

app.listen(PORT, () => console.log(`Backend running on http://localhost:${PORT}`));
