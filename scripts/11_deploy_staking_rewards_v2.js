const getOverrides = require("./getOverrides");
var prompt = require("prompt-sync")();

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    "Deploying fuel token staking V2 rewards contract with the account:",
    deployerAddress
  );
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const overrides = getOverrides();

  // Rewards Token
  const fuelTokenAddress = prompt("FuelToken address? ");
  // Staking Token
  const stakingTokenAddress = prompt("Staking token address? ");

  try {
    const StakingRewardsV2 = await ethers.getContractFactory(
      "StakingRewardsV2"
    );
    const stakingRewards = await StakingRewardsV2.deploy(
      deployerAddress,
      fuelTokenAddress,
      stakingTokenAddress,
      overrides
    );
    await stakingRewards.deployed();
    await stakingRewards.deployTransaction.wait();

    console.log(`StakingRewardsV2 deployed to: ${stakingRewards.address}`);
  } catch (e) {
    console.error(e);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
