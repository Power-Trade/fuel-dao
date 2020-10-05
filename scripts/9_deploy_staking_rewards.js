const {utils} = require('ethers');
const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

const StakingRewardsFactory = require('../artifacts/StakingRewardsFactory.json');

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    "Deploying fuel token staking rewards contract with the account:",
    deployerAddress
  );

  const overrides = getOverrides();

  const stakingRewardsFactoryAddress = prompt('Staking Rewards Factory address? ');

  const stakingRewardsFactory = new ethers.Contract(
    stakingRewardsFactoryAddress,
    StakingRewardsFactory.abi,
    deployer //provider
  );

  const stakingTokenAddress = prompt('Staking token address? ');
  const totalReward = prompt('Total PTF rewards? ');
  const rewardsDays = prompt('Rewards duration in days? (1 or more, no decimals) ');
  try {
    const tx1 = await stakingRewardsFactory.deploy(stakingTokenAddress, utils.parseEther(totalReward), rewardsDays, overrides);

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    // TODO TOM to double check this!
    // send PTF to stakingRewardsFactory - same amount as above when deploying

    console.log('Deployed staking rewards contract:', (await stakingRewardsFactory.stakingRewardsInfoByStakingToken(stakingTokenAddress)).stakingRewards);
  } catch(e) {
    console.error(e);
    console.error(`Did you send ${totalReward} PTF to the Staking Rewards Factory before running this script?`)
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
