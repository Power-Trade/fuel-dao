const { contract } = require('@nomiclabs/buidler');
const { assert } = require('./common');

const TOKEN_SUPPLY = '400000000000000000000000000';
const TIMELOCK_DELAY = '86400';
const TIMELOCK_GRACE_PERIOD = '1209600';

contract('StakingRewards', (accounts) => {
  const [, owner] = accounts;

  let MockStakingToken;
  let stakingToken;
  let Timelock;
  let timelock;
  let FuelToken;
  let rewardsToken;
  let StakingRewardsV2;
  let stakingRewards;

  beforeEach(async function() {
    // Deploy mock staking token
    MockStakingToken = await ethers.getContractFactory('MockStakingToken');
    stakingToken = await MockStakingToken.deploy();
    await stakingToken.deployed();
    console.log('MockStakingToken deployed at', stakingToken.address);

    // Deploy timelock token
    Timelock = await ethers.getContractFactory('Timelock');
    timelock = await Timelock.deploy(
      owner,
      TIMELOCK_DELAY,
      TIMELOCK_GRACE_PERIOD
    );
    await timelock.deployed();
    console.log('Timelock deployed at', timelock.address);

    FuelToken = await ethers.getContractFactory('FuelToken');
    rewardsToken = await FuelToken.deploy(
      TOKEN_SUPPLY,
      owner,
      timelock.address
    );
    await rewardsToken.deployed();
    console.log('FuelToken deployed at', rewardsToken.address);

    StakingRewardsV2 = await ethers.getContractFactory('StakingRewardsV2');

    stakingRewards = await StakingRewardsV2.deploy(
      owner,
      rewardsToken.address,
      stakingToken.address
    );
    await stakingRewards.deployed();
    console.log('StakingRewardsV2 deployed at', stakingRewards.address);
  });

  describe('Constructor & Settings', () => {
    it('should set rewards token on constructor', async () => {
      assert.equal(await stakingRewards.rewardsToken(), rewardsToken.address);
    });

    it('should staking token on constructor', async () => {
      assert.equal(await stakingRewards.stakingToken(), stakingToken.address);
    });

    it('should set owner on constructor', async () => {
      const ownerAddress = await stakingRewards.owner();
      assert.equal(ownerAddress, owner);
    });
  });
});
