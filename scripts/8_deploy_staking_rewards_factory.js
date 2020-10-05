const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    "Deploying staking rewards factory contract with the account:",
    deployerAddress
  );

  const overrides = getOverrides();

  const fuelTokenAddress = prompt('FuelToken address? ');

  const stakingRewardsFactoryFactory = await ethers.getContractFactory("StakingRewardsFactory");
  const stakingRewardsFactory = await stakingRewardsFactoryFactory.deploy(
    fuelTokenAddress,
    overrides
  );

  console.log('Staking rewards factory deployed at:', (await stakingRewardsFactory.deployed()).address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
