async function main() {
    const [deployer] = await ethers.getSigners(); // Get the first account (your address)
    console.log("Your Address:", deployer.address); // Print your address
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
