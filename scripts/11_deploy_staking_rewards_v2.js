const { utils } = require('ethers');
const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    'Deploying fuel token staking V2 rewards contract with the account:',
    deployerAddress
  );

  const overrides = getOverrides();
  
  // Rewards Distribution
  const stakingRewardsFactoryAddress = prompt('Staking Rewards Factory address? ');
  // Rewards Token
  const fuelTokenAddress = prompt('FuelToken address? ');
  // Staking Token
  const stakingTokenAddress = prompt('Staking token address? ');

  try {
    const StakingRewardsSynthetix = await ethers.getContractFactory("StakingRewards_Synthetix");
    const stakingRewards = await StakingRewardsSynthetix.deploy(deployerAddress, stakingRewardsFactoryAddress, fuelTokenAddress, stakingTokenAddress, overrides);
    await stakingRewards.deployed();
    await stakingRewards.deployTransaction.wait();

    console.log(`StakingRewards_Synthetix deployed to: ${stakingRewards.address}`)
  } catch(e) {
    console.error(e);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
