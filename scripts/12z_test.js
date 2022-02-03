const { utils } = require("ethers");
const getOverrides = require("./getOverrides");
var prompt = require("prompt-sync")();

const FuelToken = require("../artifacts/FuelToken.json");
const StakingRewardsV2 = require("../artifacts/StakingRewardsV2.json");

const fuelTokenAddress = "0x7ed3d29bc07470d0ca1b64006d33f29d552777eb";

function daysLessAnHour(days) {
    return ((days * 24) - 1) * 60 * 60; // First number is days. Convert days to seconds
}

const provider = ethers.getDefaultProvider("rinkeby");

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();

    console.log("Staking token info with the account:", deployerAddress);

    const stakingInfo = [
        {
            name: "Uniswap",
            stakingRewardsV2Address: "0xD28653cb6d776E62fb43e90c67FC18732E8ca370",
            rewardDuration: daysLessAnHour(30), 
            totalReward: "75000"
        },
        {
            name: "Balancer",
            stakingRewardsV2Address: "0xD28653cb6d776E62fb43e90c67FC18732E8ca370",
            rewardDuration: daysLessAnHour(30),
            totalReward: "75000"
        },
        {
            name: "Kyber staking 3 AMP",
            stakingRewardsV2Address: "0xD28653cb6d776E62fb43e90c67FC18732E8ca370",
            rewardDuration: daysLessAnHour(30),
            totalReward: "50000"
        }
    ];

    const overrides = getOverrides();

    const rewardsToken = new ethers.Contract(
        fuelTokenAddress,
        FuelToken.abi,
        deployer
    );

    stakingInfo.forEach(pool => {
        pool.stakingRewards = new ethers.Contract(
            pool.stakingRewardsV2Address,
            StakingRewardsV2.abi,
            deployer //provider
        );
        pool.totalRewardsInWei = utils.parseEther(pool.totalReward);
    });

    try {
        let transactionQueue = [];
        
        for (let i = 0; i < stakingInfo.length; i++) {
            const pool = stakingInfo[i];

            console.log(`Setting rewards duration to ${pool.rewardDuration} seconds.`);
            let setRewardTx = await pool.stakingRewards.setRewardsDuration(pool.rewardDuration, overrides);
            transactionQueue.push(setRewardTx.hash);
      
            // Transfer Rewards token to staking contract
            let checkBalance = await rewardsToken.balanceOf(deployerAddress);
            console.log(`${deployerAddress} has ${checkBalance} tokens inside. `);
      
            console.log(
              `Attempting transfer of ${pool.totalReward} PTF tokens from ${deployerAddress} to staking contract at ${pool.stakingRewardsV2Address}`
            );
      
            let transfer = await rewardsToken.transfer(
              pool.stakingRewards.address,
              pool.totalRewardsInWei,
              overrides
            );
            transactionQueue.push(transfer.hash);
        }

        // Wait before moving on to activate staking
        for (let i = 0; i < transactionQueue.length; i++) {
            const hash = transactionQueue[i];
            await provider.waitForTransaction(hash);
            console.log(`Hash ${i+1}/${transactionQueue.length} complete! ${hash}`);
        }

        const notify = prompt("All Transactions Done. Notify Reward Ammount?");

        transactionQueue = [];

        for (let i = 0; i < stakingInfo.length; i++) {
            const pool = stakingInfo[i];

            console.log(`Activating ${pool.name} staking rewards. ${i+1}/${stakingInfo.length}`);
            let activateTx = await pool.stakingRewards.notifyRewardAmount(
              pool.totalRewardsInWei,
              overrides
            );
            transactionQueue.push(activateTx);
        }

        for (let i = 0; i < transactionQueue.length; i++) {
            const hash = transactionQueue[i];
            await provider.waitForTransaction(hash);
            console.log(`Hash ${i+1}/${transactionQueue.length} complete! ${hash}`);
        }

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