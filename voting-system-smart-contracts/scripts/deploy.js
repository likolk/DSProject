const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const Voting = await ethers.getContractFactory("Voting");

    const initialAdmins = [
        '0x71f13461195DaB07902cac189572a3d44d949253',
        '0x92639568a4B35c4052A2243b51f75A3065104D8d',
        '0xeD8A727F4A3447ba80Bd82Fcdc37121462A512De',
    ];

    const votingAdmin = await Voting.deploy(initialAdmins);
    console.log("Voting contract deployed to:", votingAdmin.target);

    const contractAddress = { address: votingAdmin.target };
    fs.writeFileSync(path.join(__dirname, 'deployedAddress.json'), JSON.stringify(contractAddress));
    console.log('Contract address written to deployedAddress.json');



}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
