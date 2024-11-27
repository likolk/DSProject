async function main() {
    const [deployer] = await ethers.getSigners(); // Get deployer's wallet address
    console.log("Deploying contracts with the account:", deployer.address);

    // Fetch the contract factory
    const Voting = await ethers.getContractFactory("Voting");

    // Deploy the contract
    const voting = await Voting.deploy(["Alice", "Bob", "Charlie"]); // Provide candidate names
    console.log("Voting contract deployed to:", voting.target); // Use .target for contract address
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });