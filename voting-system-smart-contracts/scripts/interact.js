const readline = require("readline"); // To get input from the console

async function main() {
    const [deployer] = await ethers.getSigners();

    // Address of the deployed contract
    const votingAddress = "0xc8751Ba127C15dbFddB438CD51737184e6Cfe1c5"; // Replace with your deployed address

    // Get the contract instance
    const Voting = await ethers.getContractFactory("Voting");
    const voting = Voting.attach(votingAddress);

    // Fetch candidates
    let candidates = await voting.getCandidates();
    console.log("Candidates:");
    candidates.forEach((c, index) => {
        console.log(`Index: ${index}, Name: ${c.name}, Votes: ${c.voteCount.toString()}`);
    });

    // Use readline to get user input
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    rl.question("Enter the index of the candidate you want to vote for: ", async (candidateIndex) => {
        try {
            // Cast the vote
            await voting.vote(candidateIndex);
            console.log(`Voted for candidate at index: ${candidateIndex}`);

            // Fetch updated candidates
            candidates = await voting.getCandidates();
            console.log("Updated Candidates:");
            candidates.forEach((c, index) => {
                console.log(`Index: ${index}, Name: ${c.name}, Votes: ${c.voteCount.toString()}`);
            });
        } catch (error) {
            console.error("Error voting:", error.message);
        } finally {
            rl.close();
        }
    });
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});