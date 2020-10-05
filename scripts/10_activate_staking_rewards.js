const {utils} = require('ethers');
const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

const StakingRewardsFactory = require('../artifacts/StakingRewardsFactory.json');

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    "Staking token info with the account:",
    deployerAddress
  );

  const overrides = getOverrides();

  const stakingRewardsFactoryAddress = prompt('Staking Rewards Factory address? ');

  const stakingRewardsFactory = new ethers.Contract(
    stakingRewardsFactoryAddress,
    StakingRewardsFactory.abi,
    deployer //provider
  );

  const stakingTokenAddress = prompt('Staking token address? (NOT the staking contract address) ');
  const res = await stakingRewardsFactory.stakingRewardsInfoByStakingToken(stakingTokenAddress);

  console.log('Staking token staking rewards contract at:', res.stakingRewards);
  try {
    const tx = await stakingRewardsFactory.notifyRewardAmount(stakingTokenAddress, overrides);

    await tx.wait();

    console.log(`Staking activated!`)

  } catch(e) {
    console.error(e);
    console.error(`Did you send ${utils.formatEther(res.rewardAmount)} PTF to the Staking Rewards Factory (${stakingRewardsFactoryAddress}) before running this script?`)
  }}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
