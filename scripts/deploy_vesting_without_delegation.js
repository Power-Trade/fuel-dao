async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying vesting contract without delegation with the account:",
        deployerAddress
    );

    // const SyncTokenFactory = await ethers.getContractFactory("SyncToken");
    // const syncToken = await SyncTokenFactory.deploy(5000, deployerAddress, deployerAddress);
    // await syncToken.deployed();
    const syncTokenAddress = process.env.SYNC_TOKEN_ADDRESS;
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
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });