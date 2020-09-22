async function main() {
    const [deployer] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log(
        "Deploying deposit contract with the account:",
        deployerAddress
    );

    const depositContractFactory = await ethers.getContractFactory("VestingDepositAccount");
    const depositContract = await depositContractFactory.deploy();

    console.log('Vesting deposit contract deployed at:', (await depositContract.deployed()).address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
