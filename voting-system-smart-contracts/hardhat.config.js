require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20", // Make sure the version matches the one in your contracts
  networks: {
    hardhat: {
        chainId: 1337,

    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 1337,
    }
  },
  paths: {
    sources: "./contracts",  // Path to contracts folder
    tests: "./test",         // Path to test folder
    cache: "./cache",        // Path to cache folder
    artifacts: "./artifacts" // Path to artifacts folder
  }
  
};
