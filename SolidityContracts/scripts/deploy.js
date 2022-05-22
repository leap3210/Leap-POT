// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  // Leap token (ERC20) contract
  const _LeapERC20 = await hre.ethers.getContractFactory("LeapERC20");
  const LeapERC20 = await _LeapERC20.deploy();

  await LeapERC20.deployed();

  console.log("LeapERC20 deployed to:", LeapERC20.address);

  // Leap NFT (subscription) contract
  const _LeapNFT = await hre.ethers.getContractFactory("LeapNFT");
  const LeapNFT = await _LeapNFT.deploy();

  await LeapNFT.deployed();

  console.log("LeapNFT deployed to:", LeapNFT.address);

  // Leap NFT (subscription) contract
  const _LeapHub = await hre.ethers.getContractFactory("LeapHub");
  const LeapHub = await _LeapHub.deploy();

  await LeapHub.deployed();

  console.log("LeapHub deployed to:", LeapHub.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
