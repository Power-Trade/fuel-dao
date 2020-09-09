const csv = require('csv-parser')
const fs = require('fs')

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying vesting contract without delegation with the account:",
        deployerAddress
    );

    const syncTokenAddress = process.env.SYNC_TOKEN_ADDRESS || '0xc783df8a850f42e7F7e57013759C285caa701eB6';
    console.log('Sync Token Address', syncTokenAddress);

    const start = process.env.VESTING_START || 0;
    console.log('Start UNIX timestamp', start);

    const end = process.env.VESTING_END || 1;
    console.log('End UNIX timestamp', end);

    const cliffDuration = process.env.VESTING_CLIFF_DURATION_IN_SECONDS || 0;
    console.log('Cliff duration in seconds', cliffDuration);

    const vestingContractFactory = await ethers.getContractFactory("VestingContractWithoutDelegation");
    const vestingContract = await vestingContractFactory.deploy(
        syncTokenAddress,
        start,
        end,
        cliffDuration
    );

    await vestingContract.deployed();
    console.log('Vesting contract without delegation deployed at:', vestingContract.address);

    // approve
    const token = new ethers.Contract(
      syncTokenAddress,
      [], //abi
      null //provider
    );

    console.log('Lets set up some vesting schedules based on vesting_schedules.csv');

    const beneficiaries = [];
    const vestedAmounts = [];
    await new Promise((resolve) => {
      fs.createReadStream('./scripts/vesting_schedules.csv')
      .pipe(csv())
      .on('data', data => {
        beneficiaries.push(data.beneficiary);
        vestedAmounts.push(parseInt(data.vested));
      })
      .on('end', () => resolve());
    });

    console.log('Beneficiaries', beneficiaries);
    console.log('vestedAmounts', vestedAmounts);

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