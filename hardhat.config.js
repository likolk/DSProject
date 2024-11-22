require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.27", // Match the version in your contract
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        '0x2de83ae5affaeed85ee8ef27a43f8dd0396356822678eae12e45044b6cf0798a', 
      ],
    },
  },
  paths: {
    sources: './contracts',    
    cache: "./cache",         
    artifacts: "./artifacts",  
  },
};
