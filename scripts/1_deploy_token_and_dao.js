var prompt = require('prompt-sync')();
const getOverrides = require('./getOverrides');

async function main() {

  const overrides = getOverrides();

  const GOVERNOR_GUARDIAN = prompt('Initial guardian address? (also receives total supply) ')
  const GOVERNOR_QUORUM = "80000000000000000000000000"
  const GOVERNOR_PROPOSAL_THRESHOLD = "4000000000000000000000000"
  const GOVERNOR_VOTING_PERIOD_BLOCKS = "80640"
  const GOVERNOR_VOTING_DELAY_BLOCKS = "1"
  const TIMELOCK_DELAY = "86400"
  const TIMELOCK_GRACE_PERIOD = "1209600"
  const TOKEN_SUPPLY = "400000000000000000000000000"

  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying contracts with the account:",
    await deployer.getAddress()
  );

  const Timelock = await ethers.getContractFactory("Timelock");
  const timelock = await Timelock.deploy(await deployer.getAddress(), TIMELOCK_DELAY, TIMELOCK_GRACE_PERIOD, overrides);
  await timelock.deployed();
  console.log('Timelock deployed at', timelock.address)
  const FuelToken = await ethers.getContractFactory("FuelToken");
  const fuelToken = await FuelToken.deploy(TOKEN_SUPPLY, GOVERNOR_GUARDIAN, timelock.address, overrides);
  await fuelToken.deployed();
  console.log('FuelToken deployed at: ', fuelToken.address)
  console.log('FuelToken total supply: ', (await fuelToken.totalSupply()).toString())
  const Governor = await ethers.getContractFactory("Governor");
  const governor = await Governor.deploy(timelock.address, fuelToken.address, await deployer.getAddress(), GOVERNOR_QUORUM, GOVERNOR_PROPOSAL_THRESHOLD, GOVERNOR_VOTING_PERIOD_BLOCKS, GOVERNOR_VOTING_DELAY_BLOCKS, overrides);
  await governor.deployed();
  console.log('Governor deployed at', governor.address)
  console.log('Transferring timelock ownership to Governor');
  const tx1 = await timelock.setPendingAdmin(governor.address, overrides);
  await tx1.wait();
  const tx2 = await governor.__acceptAdmin(overrides)
  await tx2.wait();
  console.log('Transfering guardianship to guardian address')
  const tx3 = await governor.__moveGuardianship(GOVERNOR_GUARDIAN, overrides);
  await tx3.wait();
  console.log('Finished!')
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
