const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const initialAdmins = [
        '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'
    ];
    const tokenAddress = '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC';

    const VotingContract = await ethers.getContractFactory("VotingContract");

    try {
        const votingContract = await VotingContract.deploy(initialAdmins, tokenAddress, {
            gasLimit: 8000000
        });
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