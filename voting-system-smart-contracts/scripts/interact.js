const readline = require("readline"); // To get input from the console

async function main() {
    const [deployer] = await ethers.getSigners();
    const votingAddress = "0xc8751Ba127C15dbFddB438CD51737184e6Cfe1c5";

    const Voting = await ethers.getContractFactory("Voting");
    const voting = Voting.attach(votingAddress);

    let candidates = await voting.getCandidates();
    console.log("Candidates:");
    candidates.forEach((c, index) => {
        console.log(`Index: ${index}, Name: ${c.name}, Votes: ${c.voteCount.toString()}`);
    });

    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    rl.question("Enter the index of the candidate you want to vote for: ", async (candidateIndex) => {
        try {
            await voting.vote(candidateIndex);
            console.log(`Voted for candidate at index: ${candidateIndex}`);

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