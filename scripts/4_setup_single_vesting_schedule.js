const {utils} = require('ethers');

const FuelToken = require('../artifacts/FuelToken.json');
const VestingContract = require('../artifacts/VestingContract.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Setting up vesting schedule using the following account:",
        deployerAddress
    );

    const fuelTokenAddress = process.env.FUEL_TOKEN_ADDRESS;
    const token = new ethers.Contract(
        fuelTokenAddress,
        FuelToken.abi,
        deployer //provider
    );

    const vestingContractAddress = process.env.VESTING_CONTRACT_ADDRESS;
    const vestingContract = new ethers.Contract(
        vestingContractAddress,
        VestingContract.abi,
        deployer
    );

    // The amount will be converted to a WEI value - to 18 decimal places
    const vestedAmount = process.env.NEW_VESTING_SCHEDULE_WITH_DELEGATION_AMOUNT;
    const tx1 = await token.approve(vestingContract.address, utils.parseEther(vestedAmount));

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    const beneficiary = process.env.NEW_VESTING_SCHEDULE_WITH_DELEGATION_BENEFICIARY;
    await vestingContract.createVestingSchedule(
        beneficiary,// beneficiary
        utils.parseEther(vestedAmount)// amount
    );
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
