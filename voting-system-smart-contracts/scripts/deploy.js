const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Ensure you pass both arguments: the array of initial admins and the token address
    const initialAdmins = [
        '0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e', // Address as-is
    ];
    const tokenAddress = '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199'; // Address as-is

    const VotingContract = await ethers.getContractFactory("VotingContract");

    // Deploy the contract with both the initialAdmins array and the token address
    const votingContract = await VotingContract.deploy(initialAdmins, tokenAddress);
    await votingContract.deployed(); // Ensure contract deployment is completed
    console.log("Voting contract deployed to:", votingContract.address);

    const deployedAddressPath = path.join(__dirname, "deployedAddress.json");

    // Read existing addresses if the file exists, else initialize with an empty array
    let existingAddresses = [];
    if (fs.existsSync(deployedAddressPath)) {
        try {
            const data = fs.readFileSync(deployedAddressPath, "utf-8");
            existingAddresses = JSON.parse(data);
        } catch (error) {
            console.error("Error reading deployedAddress.json:", error);
        }
    }

    // Append the new address
    existingAddresses.push({ address: votingContract.address });

    // Write back to the JSON file
    fs.writeFileSync(deployedAddressPath, JSON.stringify(existingAddresses, null, 2));
    console.log("Contract address appended to deployedAddress.json");
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});