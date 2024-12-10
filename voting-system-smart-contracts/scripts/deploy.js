const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const initialAdmins = [
        '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'
    ];
    const tokenAddress = '0x9A676e781A523b5d0C0e43731313A708CB607508';

    const VotingContract = await ethers.getContractFactory("VotingContract");

    try {
        const votingContract = await VotingContract.deploy(initialAdmins, tokenAddress,{
            value: ethers.parseEther("1")
          }
        );
        await votingContract.deploymentTransaction().wait();

        const contractAddress = votingContract.target;
        console.log("Voting contract deployed to:", contractAddress);

        const deployedAddressPath = path.join(__dirname, "deployedAddress.json");

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