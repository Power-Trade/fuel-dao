async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying vesting contract with the account:",
        deployerAddress
    );

    const syncTokenAddress = process.env.SYNC_TOKEN_ADDRESS;
    console.log('Sync Token Address', syncTokenAddress);

    const baseVestingDepositAccountAddress = process.env.BASE_DEPOSIT_ACCOUNT_ADDRESS;
    console.log('Base vesting deposit account', baseVestingDepositAccountAddress);

    const start = process.env.VESTING_START;
    console.log('Start UNIX timestamp', start);

    const end = process.env.VESTING_END;
    console.log('End UNIX timestamp', end);

    const cliffDuration = process.env.VESTING_CLIFF_DURATION_IN_SECONDS;
    console.log('Cliff duration in seconds', cliffDuration);

    const vestingContractFactory = await ethers.getContractFactory("VestingContract");
    const vestingContract = await vestingContractFactory.deploy(
        syncTokenAddress,
        baseVestingDepositAccountAddress,
        start,
        end,
        cliffDuration
    );

    console.log('Vesting contract deployed at:', (await vestingContract.deployed()).address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
