var prompt = require('prompt-sync')();
const {utils} = require('ethers');
const getOverrides = require('./getOverrides');

const FuelToken = require('../artifacts/FuelToken.json');
const VestingContract = require('../artifacts/VestingContract.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Setting up vesting schedule using the following account:",
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

    // The amount will be converted to a WEI value - to 18 decimal places
    const vestedAmount = prompt('Vesting token amount (e.g. 1.5)? ');
    const tx1 = await token.approve(vestingContractAddress, utils.parseEther(vestedAmount), overrides);

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    const beneficiary = prompt('Beneficiary address? ');;
    const tx2 = await vestingContract.createVestingSchedule(
        beneficiary,// beneficiary
        utils.parseEther(vestedAmount),// amount
        overrides
    );

    await tx2.wait();
    console.log('Done!');
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
