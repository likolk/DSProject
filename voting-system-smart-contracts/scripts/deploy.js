const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // Ensure you pass both arguments: the array of initial admins and the token address
    const initialAdmins = [
        '0x71f13461195DaB07902cac189572a3d44d949253',
        '0x92639568a4B35c4052A2243b51f75A3065104D8d',
        '0xeD8A727F4A3447ba80Bd82Fcdc37121462A512De',
    ];

    // Replace this with the actual token address (ensure it's a valid address)
    const tokenAddress = '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'; 


    const votingContract = await ethers.getContractFactory("VotingContract");

    // Deploy the contract with both the initialAdmins array and the token address
    const votingAdmin = await votingContract.deploy(initialAdmins, tokenAddress);
    console.log("Voting contract deployed to:", votingAdmin.target);

    const contractAddress = { address: votingAdmin.target };
    fs.writeFileSync(path.join(__dirname, 'deployedAddress.json'), JSON.stringify(contractAddress));
    console.log('Contract address written to deployedAddress.json');




    
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
