# Sync DAO Solidity Smart Contracts

## Seting up your environent

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

* Timelock (DAO treasury & agent) [0x06215b62731E53f43b973FA9951Cf1C042eaAEA3](https://etherscan.io/address/0x06215b62731E53f43b973FA9951Cf1C042eaAEA3)
* SyncToken [0x6DCEd71d2488eEf71703218A68c6052665B57709](https://etherscan.io/address/0x6DCEd71d2488eEf71703218A68c6052665B57709)
* Governor [0x23795568E29BD77a08dC2A0CF710908eA677AEa7](https://etherscan.io/address/0x23795568E29BD77a08dC2A0CF710908eA677AEa7)
* VestingDepositAccount
* VestingContract
* VestingContractWithoutDelegation

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