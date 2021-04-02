async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log("Deploying contracts with the account:", deployerAddress);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const MockStakingToken = await ethers.getContractFactory("MockStakingToken");
  const mockStakingToken = await MockStakingToken.deploy(
    "Mock Staking Token",
    "MST",
    18,
    1000000
  );

  console.log("MockStakingToken address:", mockStakingToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
