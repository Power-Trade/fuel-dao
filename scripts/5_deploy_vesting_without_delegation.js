var prompt = require('prompt-sync')();
const getOverrides = require('./getOverrides');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying vesting contract without delegation with the account:",
        deployerAddress
    );
    const overrides = getOverrides();

    const fuelTokenAddress = prompt('FuelToken address? ');

    const start = "1600956000";
    console.log('Start UNIX timestamp', start);

    const end = "1608818400";
    console.log('End UNIX timestamp', end);

    const cliffDuration = 0;
    console.log('Cliff duration in seconds', cliffDuration);

    const vestingContractFactory = await ethers.getContractFactory("VestingContractWithoutDelegation");
    const vestingContract = await vestingContractFactory.deploy(
        fuelTokenAddress,
        start,
        end,
        cliffDuration,
        overrides
    );

    await vestingContract.deployed();
    console.log('Vesting contract without delegation deployed at:', vestingContract.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
