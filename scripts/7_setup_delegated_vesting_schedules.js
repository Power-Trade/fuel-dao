var prompt = require('prompt-sync')();
const _ = require('lodash');
const csv = require('csv-parser');
const fs = require('fs');
const {BigNumber, utils} = require('ethers');
const getOverrides = require('./getOverrides');

const FuelToken = require('../artifacts/FuelToken.json');
const VestingContract = require('../artifacts/VestingContract.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Setting up vesting schedules with delegated voting rights with the account:",
        deployerAddress
    );

    const overrides = getOverrides();

    const fuelTokenAddress = prompt('FuelToken address? ');
    const token = new ethers.Contract(
        fuelTokenAddress,
        FuelToken.abi,
        deployer //provider
    );

    const vestingContractAddress = prompt('VestingContract address? ');
    const vestingContract = new ethers.Contract(
        vestingContractAddress,
        VestingContract.abi,
        deployer
    );

    const sourceFile = prompt('Source csv file name? must be in the same directory as this script ')
    console.log(`Lets set up some vesting schedules based on ${sourceFile}`);

    let startFrom = prompt('Start from line (inclusive)? input 2 or more ')
    let endAt = prompt(`End at line (inclusive)? input ${startFrom} or more `)
    startFrom = Number(startFrom) - 2
    endAt = Number(endAt) - 2

    let beneficiaries = [];
    let vestedAmounts = [];
    await new Promise((resolve) => {
        fs.createReadStream(`./scripts/${sourceFile}`)
            .pipe(csv())
            .on('data', data => {
                beneficiaries.push(data.beneficiary);
                vestedAmounts.push(utils.parseEther(data.vested)); // convert to an 18 DP amount ( WEI equiv )
            })
            .on('end', () => resolve());
    });

    beneficiaries = beneficiaries.filter((_, i) => i >= startFrom && i <= endAt)
    vestedAmounts = vestedAmounts.filter((_, i) => i >= startFrom && i <= endAt)

    // Approve the vesting contract for sum from vestedAmounts
    let sumVestedAmounts = BigNumber.from('0');
    for(let i = 0; i < vestedAmounts.length; i++) {
        sumVestedAmounts = sumVestedAmounts.add(vestedAmounts[i])
    }

    console.log('Calling Approval for creating vesting schedules to', utils.formatEther(sumVestedAmounts));
    const tx1 = await token.approve(vestingContract.address, sumVestedAmounts, overrides);

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    // Create the vesting schedules
    for (let i = 0; i < beneficiaries.length; i++) {
        console.log(`Attempting to vest ${utils.formatEther(vestedAmounts[i])} for ${beneficiaries[i]}`)
        try {
            const tx2 = await vestingContract.createVestingSchedule(
                beneficiaries[i],
                vestedAmounts[i],
                overrides
            );
            await tx2.wait();
            console.log(`Successfully vested ${beneficiaries[i]}`)
        } catch(e) {
            console.log(`FAILED AT ${beneficiaries[i]}. MAKE SURE PAYMENT WAS NOT IN FACT SENT AND RETRY STARTING FROM LINE ${i+2}`)
            console.log(e);
            break;
        }
    }
    console.log('Done!')
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
