const _ = require('lodash');
const csv = require('csv-parser')
const fs = require('fs')
const {BigNumber, utils} = require('ethers');

const SyncToken = require('../artifacts/FuelToken.json');
const VestingContractWithoutDelegation = require('../artifacts/VestingContractWithoutDelegation.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Setting up vesting schedules without voting rights with the account:",
        deployerAddress
    );

    const syncTokenAddress = process.env.SYNC_TOKEN_ADDRESS;
    const token = new ethers.Contract(
        syncTokenAddress,
        SyncToken.abi,
        deployer //provider
    );

    console.log('Token address:', token.address);

    const vestingContractAddress = process.env.VESTING_CONTRACT_WITHOUT_DELEGATION;
    const vestingContract = new ethers.Contract(
        vestingContractAddress,
        VestingContractWithoutDelegation.abi,
        deployer
    );

    console.log('Lets set up some vesting schedules based on vesting_schedules_without_delegation.csv');

    const beneficiaries = [];
    const vestedAmounts = [];
    await new Promise((resolve) => {
        fs.createReadStream('./scripts/vesting_schedules_without_delegation.csv')
            .pipe(csv())
            .on('data', data => {
                beneficiaries.push(data.beneficiary);
                vestedAmounts.push(utils.parseEther(data.vested)); // convert from a to 18 DP amount to a WEI equiv
            })
            .on('end', () => resolve());
    });

    console.log('Beneficiaries', beneficiaries);
    console.log('vestedAmounts', vestedAmounts);

    // Approve the vesting contract for sum from vestedAmounts
    let sumVestedAmounts = BigNumber.from('0');
    for(let i = 0; i < vestedAmounts.length; i++) {
        sumVestedAmounts = sumVestedAmounts.add(vestedAmounts[i])
    }

    console.log('Approval required for creating vesting schedules to 18 DP', utils.formatEther(sumVestedAmounts));
    const tx1 = await token.approve(vestingContract.address, sumVestedAmounts);

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    // Create the vesting schedules
    await vestingContract.createVestingSchedules(
        beneficiaries,
        vestedAmounts
    );
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
