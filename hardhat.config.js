require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.21", 
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        // Add private keys of Ganache accounts, or use process.env for security
       '0x00BfAc1357103a794a51CbEB561B0f9126D2641b',
      ],
    },
  },
};
