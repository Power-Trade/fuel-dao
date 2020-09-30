const {utils} = require('ethers');

const StakingRewardsFactory = require('../artifacts/StakingRewardsFactory.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();

    console.log(
        "Deploying fuel token staking rewards contract with the account:",
        deployerAddress
    );

    const stakingRewardsFactoryAddress = process.env.STAKING_REWARDS_FACTORY_ADDRESS;

    const stakingRewardsFactory = new ethers.Contract(
      stakingRewardsFactoryAddress,
      StakingRewardsFactory.abi,
      deployer //provider
    );


    const stakingTokenAddress = process.env.STAKING_TOKEN_ADDRESS;
    const tx1 = await stakingRewardsFactory.deploy(stakingTokenAddress, utils.parseEther("10"));

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    console.log('Deployed staking rewards contract with staking token: ', stakingTokenAddress);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
