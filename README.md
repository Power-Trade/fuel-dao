# Fuel DAO Solidity Smart Contracts

## Setting up your environent

This is a node.js project so you need to ensure you install all of your dependencies with:

```
npm i
```

## Deployment

Deployment and transactional scripts can be found in the `scripts/` directory. The format for running a script is

```
npx buidler run --network <your_network> scripts/<chosen_script>
```

It's important to have a `.env` file set up which includes important things like setting the private key for the deployment account.

Please see `.env.example` for some of the properties you set up. Different scripts will use different properties.

## Mainnet Contracts

* Timelock (DAO treasury & agent): [0x9c48850a6e5b9742ed78fe4c0b820ec15d108ad6](https://etherscan.io/address/0x9c48850a6e5b9742ed78fe4c0b820ec15d108ad6)
* FuelToken: [0xc57d533c50bc22247d49a368880fb49a1caa39f7](https://etherscan.io/address/0xc57d533c50bc22247d49a368880fb49a1caa39f7)
* Governor: [0x951101e8de28d5d45844e639897e700a03931f83](https://etherscan.io/address/0x951101e8de28d5d45844e639897e700a03931f83)
* VestingDepositAccount: [0xDFDD6014A6b92Ed74A3b34f171d6b07CDf8d91dE](https://etherscan.io/address/0xDFDD6014A6b92Ed74A3b34f171d6b07CDf8d91dE)
* VestingContractWithoutDelegation: [0x6a03796E882BED3B1FF1747b8563f3C2c11F0Ff3](https://etherscan.io/address/0x6a03796E882BED3B1FF1747b8563f3C2c11F0Ff3)
* VestingContract (2yr): [0x63005B1bE2BF27B3B563daf7781BE46A1Ff17D1e](https://etherscan.io/address/0x63005B1bE2BF27B3B563daf7781BE46A1Ff17D1e)
* VestingContract (1yr): [0x4aABE30996E6A57Bd5d836e20fBCAa62e0BAa176](https://etherscan.io/address/0x4aABE30996E6A57Bd5d836e20fBCAa62e0BAa176)
* VestingContract (4yr 6m wait): [0x231FEd774ed1b3F4e4bA53d0E62b2E24C661880f](https://etherscan.io/address/0x231FEd774ed1b3F4e4bA53d0E62b2E24C661880f)
* VestingContract (2yr 3m wait): [0x07010F6Ec127610B11633374C383a2FE5bD80CC7](https://etherscan.io/address/0x07010F6Ec127610B11633374C383a2FE5bD80CC7)
* StakingRewardsFactory: [0xEa3241aC9dd3e5e29989399908ea6A4460E748F8](https://etherscan.io/address/0xEa3241aC9dd3e5e29989399908ea6A4460E748F8)
* StakingRewards (Oct 5, 2020): [0x1a72663a12d2F2F115f5B84065c5c290674fBe16](https://etherscan.io/address/0x1a72663a12d2F2F115f5B84065c5c290674fBe16)

## Vesting Contracts

### Running Tests

In terminal start `npx buidler node`

In another terminal `npx buidler test`

### GAS Reporting

Check gas reporting is enabled in `buidler.config.js`
```
    gasReporter: {
        currency: 'USD',
        enabled: true
    },
```

`npx buidler test --network localhost`

```
·---------------------------------------------------------------------------|---------------------------|-------------|----------------------------·
|                           Solc version: 0.5.16                            ·  Optimizer enabled: true  ·  Runs: 200  ·  Block limit: 9500000 gas  │
············································································|···························|·············|·····························
|  Methods                                                                  ·               74 gwei/gas               ·       343.04 usd/eth       │
··············································|·····························|·············|·············|·············|··············|··············
|  Contract                                   ·  Method                     ·  Min        ·  Max        ·  Avg        ·  # calls     ·  usd (avg)  │
··············································|·····························|·············|·············|·············|··············|··············
|  SyncToken                                  ·  approve                    ·      45623  ·      45635  ·      45635  ·          99  ·       1.16  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithFixedTime               ·  createVestingSchedule      ·     304726  ·     304738  ·     304737  ·          40  ·       7.74  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithFixedTime               ·  drawDown                   ·      99482  ·     164131  ·     146897  ·          29  ·       3.73  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithFixedTime               ·  fixTime                    ·      22274  ·      41474  ·      30216  ·          89  ·       0.77  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithFixedTime               ·  updateScheduleBeneficiary  ·          -  ·          -  ·     303141  ·           2  ·       7.70  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithoutDelegationFixedTime  ·  createVestingSchedule      ·      90284  ·      90296  ·      90295  ·          35  ·       2.29  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithoutDelegationFixedTime  ·  createVestingSchedules     ·          -  ·          -  ·     174303  ·           2  ·       4.42  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithoutDelegationFixedTime  ·  drawDown                   ·      61071  ·     125741  ·     108497  ·          29  ·       2.75  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingContractWithoutDelegationFixedTime  ·  fixTime                    ·      22296  ·      41496  ·      36231  ·          89  ·       0.92  │
··············································|·····························|·············|·············|·············|··············|··············
|  VestingDepositAccount                      ·  init                       ·          -  ·          -  ·      85807  ·           9  ·       2.18  │
··············································|·····························|·············|·············|·············|··············|··············
|  Deployments                                                              ·                                         ·  % of limit  ·             │
············································································|·············|·············|·············|··············|··············
|  SyncToken                                                                ·          -  ·          -  ·    1965411  ·      20.7 %  ·      49.89  │
············································································|·············|·············|·············|··············|··············
|  VestingContractWithFixedTime                                             ·    1390532  ·    1409768  ·    1391755  ·      14.7 %  ·      35.33  │
············································································|·············|·············|·············|··············|··············
|  VestingContractWithoutDelegationFixedTime                                ·    1085009  ·    1123505  ·    1104290  ·      11.6 %  ·      28.03  │
············································································|·············|·············|·············|··············|··············
|  VestingDepositAccount                                                    ·          -  ·          -  ·     341206  ·       3.6 %  ·       8.66  │
·---------------------------------------------------------------------------|-------------|-------------|-------------|--------------|-------------·
```

### Coverage

`npx buidler coverage --network coverage`

```
------------------------------------------------|----------|----------|----------|----------|----------------|
File                                            |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
------------------------------------------------|----------|----------|----------|----------|----------------|
 contracts/                                     |    42.31 |    33.72 |    43.75 |    42.74 |                |
  CloneFactory.sol                              |      100 |      100 |      100 |      100 |                |
  Governor.sol                                  |        0 |        0 |        0 |        0 |... 320,321,322 |
  IERC20.sol                                    |      100 |      100 |      100 |      100 |                |
  ReentrancyGuard.sol                           |      100 |       50 |      100 |      100 |                |
  SafeMath.sol                                  |    59.26 |    33.33 |       60 |    59.26 |... 168,183,184 |
  Staking.sol                                   |        0 |        0 |        0 |        0 |... 175,176,178 |
  SyncToken.sol                                 |    55.36 |    34.78 |       60 |    54.87 |... 367,368,369 |
  Timelock.sol                                  |        0 |        0 |        0 |        0 |... 115,117,122 |
  VestingContract.sol                           |    96.61 |    79.41 |    90.91 |    96.61 |        262,270 |
  VestingContractWithoutDelegation.sol          |    97.96 |    90.63 |    91.67 |    97.96 |            207 |
  VestingDepositAccount.sol                     |      100 |      100 |      100 |      100 |                |
  VestingStakingFactory.sol                     |        0 |        0 |        0 |        0 |... 32,35,38,41 |
  rkDaiStaking.sol                              |      100 |      100 |        0 |      100 |                |
 contracts/mock/                                |     87.5 |       75 |      100 |     87.5 |                |
  VestingContractWithFixedTime.sol              |       75 |       50 |      100 |       75 |             30 |
  VestingContractWithoutDelegationFixedTime.sol |      100 |      100 |      100 |      100 |                |
------------------------------------------------|----------|----------|----------|----------|----------------|
All files                                       |    43.07 |    34.35 |    46.61 |    43.49 |                |
------------------------------------------------|----------|----------|----------|----------|----------------|
```
