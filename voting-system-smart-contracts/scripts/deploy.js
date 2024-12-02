const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Ensure you pass both arguments: the array of initial admins and the token address
    const initialAdmins = [
        '0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e',
    ];

    const tokenAddress = '0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199';  // Replace with actual token address

    const VotingContract = await ethers.getContractFactory("VotingContract");

    // Deploy the contract with both the initialAdmins array and the token address
    const votingContract = await VotingContract.deploy(initialAdmins, tokenAddress);
    console.log("Voting contract deployed to:", votingContract.address);

    const contractAddress = { address: votingContract.address };
    fs.writeFileSync(path.join(__dirname, 'deployedAddress.json'), JSON.stringify(contractAddress));
    console.log('Contract address written to deployedAddress.json');
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
