var prompt = require('prompt-sync')();
const getOverrides = require('./getOverrides');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying vesting contract with the account:",
        deployerAddress
    );
    const overrides = getOverrides();

    const fuelTokenAddress = prompt('FuelToken address? ');

    const baseVestingDepositAccountAddress = prompt('VestingDepositAccount address? ');

    const start = "1600956000";
    console.log('Start UNIX timestamp', start);

    const vestingYears = Number(prompt('Number of vesting years? (1 or 2) '));
    if(vestingYears !== 1 && vestingYears !== 2) throw new Error('Invalid vesting year number')
    const end = vestingYears === 1? "1632492000": "1664028000"
    console.log('End UNIX timestamp', end);

    const cliffDuration = 0
    console.log('Cliff duration in seconds', cliffDuration);

    const vestingContractFactory = await ethers.getContractFactory("VestingContract");
    const vestingContract = await vestingContractFactory.deploy(
        fuelTokenAddress,
        baseVestingDepositAccountAddress,
        start,
        end,
        cliffDuration,
        overrides
    );

    console.log(String(vestingYears), 'year vesting contract deployed at:', (await vestingContract.deployed()).address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
