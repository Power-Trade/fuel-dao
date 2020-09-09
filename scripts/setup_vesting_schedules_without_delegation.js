const _ = require('lodash');
const SyncToken = require('../artifacts/SyncToken.json');
const VestingContractWithoutDelegation = require('../artifacts/VestingContractWithoutDelegation.json');

const csv = require('csv-parser')
const fs = require('fs')

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

      const vestingContractAddress = process.env.VESTING_CONTRACT_ADDRESS;
      const vestingContract = new ethers.Contract(
          vestingContractAddress,
          VestingContractWithoutDelegation.abi,
          deployer
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

      // Approve the vesting contract for sum from vestedAmounts
      const sumVestedAmounts = _.sum(vestedAmounts);

      console.log('Approval required for creating vesting schedules', sumVestedAmounts);
      await token.approve(vestingContract.address, sumVestedAmounts);
  
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