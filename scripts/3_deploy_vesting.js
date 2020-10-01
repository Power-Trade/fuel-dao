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

    const vestingYears = prompt('Number of vesting years? (1, 2, T for Team or P for Partnerships) ');
    let start;
    let end;
    if(Number(vestingYears) === 1) {
        start = "1600956000"
        end = "1632492000"
    } else if(Number(vestingYears) === 2) {
        start = "1600956000"
        end = "1664028000"
    } else if(vestingYears === "T") {
        start = "1616594400"
        end = "1727186400"
    } else if(vestingYears === "P") {
        start = "1608818400"
        end = "1664028000"
    } else {
        throw new Error('Invalid vesting years value')
    }
    
    console.log('Start UNIX timestamp', start);
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
