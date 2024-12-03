const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const initialAdmins = [
        '0xdD2FD4581271e230360230F9337D5c0430Bf44C0',
        '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199',
        '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
        '0x5FbDB2315678afecb367f032d93F642f64180aa3'
    ];
    const tokenAddress = '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199';

    const VotingContract = await ethers.getContractFactory("VotingContract");

    try {
        const votingContract = await VotingContract.deploy(initialAdmins, tokenAddress);
        await votingContract.deploymentTransaction().wait();

        const contractAddress = votingContract.target;
        console.log("Voting contract deployed to:", contractAddress);

        const deployedAddressPath = path.join(__dirname, "deployedAddress.json");

        // Save as an object with "address" key
        fs.writeFileSync(deployedAddressPath, JSON.stringify({ address: contractAddress }, null, 2));
        console.log("Contract address saved to deployedAddress.json");

    } catch (error) {
        console.error("Error deploying contract:", error);
    }
}

main().catch((error) => {
    console.error("Script failed with error:", error);
    process.exit(1);
});