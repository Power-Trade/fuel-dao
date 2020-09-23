async function main() {

  const GOVERNOR_GUARDIAN = process.env.GOVERNOR_GUARDIAN
  const GOVERNOR_QUORUM = process.env.GOVERNOR_QUORUM
  const GOVERNOR_PROPOSAL_THRESHOLD = process.env.GOVERNOR_PROPOSAL_THRESHOLD
  const GOVERNOR_VOTING_PERIOD_BLOCKS = process.env.GOVERNOR_VOTING_PERIOD_BLOCKS
  const GOVERNOR_VOTING_DELAY_BLOCKS = process.env.GOVERNOR_VOTING_DELAY_BLOCKS
  const TIMELOCK_DELAY = process.env.TIMELOCK_DELAY
  const TIMELOCK_GRACE_PERIOD = process.env.TIMELOCK_GRACE_PERIOD
  const TOKEN_SUPPLY = process.env.TOKEN_SUPPLY

  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying contracts with the account:",
    await deployer.getAddress()
  );

  const Timelock = await ethers.getContractFactory("Timelock");
  const timelock = await Timelock.deploy(await deployer.getAddress(), TIMELOCK_DELAY, TIMELOCK_GRACE_PERIOD);
  await timelock.deployed();
  console.log('Timelock deployed at', timelock.address)
  const FuelToken = await ethers.getContractFactory("FuelToken");
  const fuelToken = await FuelToken.deploy(TOKEN_SUPPLY, GOVERNOR_GUARDIAN, timelock.address);
  await fuelToken.deployed();
  console.log('FuelToken deployed at', fuelToken.address)
  const Governor = await ethers.getContractFactory("Governor");
  const governor = await Governor.deploy(timelock.address, fuelToken.address, await deployer.getAddress(), GOVERNOR_QUORUM, GOVERNOR_PROPOSAL_THRESHOLD, GOVERNOR_VOTING_PERIOD_BLOCKS, GOVERNOR_VOTING_DELAY_BLOCKS);
  await governor.deployed();
  console.log('Governor deployed at', governor.address)
  console.log('Transferring timelock ownership to Governor');
  const tx1 = await timelock.setPendingAdmin(governor.address);
  await tx1.wait();
  const tx2 = await governor.__acceptAdmin()
  await tx2.wait();
  console.log('Transfering guardianship to guardian address')
  const tx3 = await governor.__moveGuardianship(GOVERNOR_GUARDIAN);
  await tx3.wait();
  console.log('Finished!')
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
