const {utils} = require('ethers');
const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

const StakingRewardsSynthetix = require('../artifacts/StakingRewards_Synthetix.json');

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log(
    "Staking token info with the account:",
    deployerAddress
  );

  const overrides = getOverrides();

  const stakingRewardsV2Address = prompt('StakingRewards_Synthetix address? ');
  const rewardsDays = prompt('Rewards duration in days? (1 or more, no decimals) ');
  const totalReward = prompt('Total PTF rewards? ');

  const stakingRewards = new ethers.Contract(
    stakingRewardsV2Address,
    StakingRewardsSynthetix.abi,
    deployer //provider
  );

  try {
    const tx = await stakingRewards.setRewardsDuration(rewardsDays, overrides);
    console.log(tx)
    await tx.wait();
    
    const totalRewardsInEther = utils.parseEther(totalReward);
    const tx2 = await stakingRewards.notifyRewardAmount(totalRewardsInEther, overrides);
    await tx2.wait();

    console.log(`Staking V2 activated!`)

  } catch(e) {
    console.error(e);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
