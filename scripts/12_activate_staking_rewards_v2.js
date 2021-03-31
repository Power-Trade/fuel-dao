const { utils } = require('ethers');
const getOverrides = require('./getOverrides');
var prompt = require('prompt-sync')();

const FuelToken = require('../artifacts/FuelToken.json');
const StakingRewardsV2 = require('../artifacts/StakingRewardsV2.json');

async function main() {
  const [deployer] = await ethers.getSigners();
  const deployerAddress = await deployer.getAddress();

  console.log('Staking token info with the account:', deployerAddress);

  const overrides = getOverrides();

  const fuelTokenAddress = prompt('Fuel Token address? ');
  const stakingRewardsV2Address = prompt('StakingRewardsV2 address? ');
  const rewardsDays = prompt(
    'Rewards duration in days? (1 or more, no decimals) '
  );
  const totalReward = prompt('Total PTF rewards? ');

  const rewardsToken = new ethers.Contract(
    fuelTokenAddress,
    FuelToken.abi,
    deployer
  );

  const stakingRewards = new ethers.Contract(
    stakingRewardsV2Address,
    StakingRewardsV2.abi,
    deployer //provider
  );

  try {
    const tx = await stakingRewards.setRewardsDuration(rewardsDays, overrides);
    await tx.wait();

    const totalRewardsInWei = utils.parseEther(totalReward);

    // Emulate the transfer that is happening inside the V1 StakingRewardsFactory
    const transfer = await rewardsToken.transfer(
      stakingRewards.address,
      totalRewardsInWei
    );
    await transfer.wait();

    console.log(
      'Fuel tokens transfered into staking rewards address. Staking address supply now is (in wei): ',
      (await rewardsToken.balanceOf(stakingRewards.address)).toString()
    );

    const tx2 = await stakingRewards.notifyRewardAmount(
      totalRewardsInWei,
      overrides
    );
    await tx2.wait();

    console.log(`Staking V2 activated!`);
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
