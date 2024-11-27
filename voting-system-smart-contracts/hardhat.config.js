require("@nomicfoundation/hardhat-ethers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.26",
    networks: {
        localhost: {
            url: "http://127.0.0.1:7545", // Ganache network
        },
    },
};
