const {utils} = require('ethers');

const StakingRewardsFactory = require('../artifacts/StakingRewardsFactory.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();

    console.log(
        "Staking token info with the account:",
        deployerAddress
    );

    const stakingRewardsFactoryAddress = process.env.STAKING_REWARDS_FACTORY_ADDRESS;

    const stakingRewardsFactory = new ethers.Contract(
      stakingRewardsFactoryAddress,
      StakingRewardsFactory.abi,
      deployer //provider
    );

    const stakingtokenaddress = process.env.STAKING_TOKEN_ADDRESS;
    const res = await stakingRewardsFactory.stakingRewardsInfoByStakingToken(stakingtokenaddress);

    console.log('Staking token staking rewards contract at:', res);


    const tx = await stakingRewardsFactory.notifyRewardAmount(stakingtokenaddress)

    console.log(tx);
    await tx.wait();

    console.log('Staking token staking notifyRewardAmount complete');
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
