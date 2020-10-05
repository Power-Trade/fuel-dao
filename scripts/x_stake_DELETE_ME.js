const {utils} = require('ethers');

const StakingRewards = require('../artifacts/StakingRewards.json');
const ERC20 = require('../artifacts/ERC20.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();

    console.log(
        "Staking with the account:",
        deployerAddress
    );

    const stakingRewardsAddress = process.env.STAKING_REWARDS_ADDRESS;

    const stakingRewards = new ethers.Contract(
      stakingRewardsAddress,
      StakingRewards.abi,
      deployer //provider
    );

    const stakingTokenAddress = process.env.STAKING_TOKEN_ADDRESS;
    const stakingToken = new ethers.Contract(
      stakingTokenAddress,
      ERC20.abi,
      deployer //provider
    );

    let tx = await stakingToken.approve(stakingRewardsAddress, utils.parseEther("10"));
    console.log('Approving...', tx);
    await tx.wait();

    tx = await stakingRewards.stake(utils.parseEther("10"));

    console.log('Staking...', tx);
    await tx.wait();

    console.log('Staking complete');
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
