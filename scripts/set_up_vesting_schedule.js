const {utils} = require('ethers');

const SyncToken = require('../artifacts/FuelToken.json');
const VestingContract = require('../artifacts/VestingContract.json');

async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Setting up vesting schedule using the following account:",
        deployerAddress
    );

    const syncTokenAddress = process.env.SYNC_TOKEN_ADDRESS;
    const token = new ethers.Contract(
        syncTokenAddress,
        SyncToken.abi,
        deployer //provider
    );

    const vestingContractAddress = process.env.VESTING_CONTRACT_ADDRESS;
    const vestingContract = new ethers.Contract(
        vestingContractAddress,
        VestingContract.abi,
        deployer
    );

    //TODO: When setting up a schedule, uncomment the below and specify an amount. 25K below would be converted to WEI
    //const vestedAmount = "25000";
    const tx1 = await token.approve(vestingContract.address, utils.parseEther(vestedAmount));

    // we need the approval to go through before creating a schedule
    await tx1.wait();

    //const beneficiary = "0x551433A38041D898C599940dC3c3F96bBd7876aA";
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
