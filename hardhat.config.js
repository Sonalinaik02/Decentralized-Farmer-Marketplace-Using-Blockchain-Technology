require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    amoy: {
      url: process.env.ALCHEMY_URL, // Polygon Amoy RPC
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
