const hre = require("hardhat");

async function main() {
  // Deploy mock INR/MATIC feed first
  const MockFeed = await hre.ethers.getContractFactory("MockV3Aggregator");
  const mock = await MockFeed.deploy(100000000); // 1 MATIC = 100 INR (example)
  await mock.deployed();
  console.log("Mock feed deployed at:", mock.address);

  const Marketplace = await hre.ethers.getContractFactory("FarmerMarketplace");
  const marketplace = await Marketplace.deploy(mock.address);
  await marketplace.deployed();

  console.log("FarmerMarketplace deployed to:", marketplace.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
