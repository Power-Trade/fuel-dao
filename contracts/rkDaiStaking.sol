pragma solidity ^0.5.16;

import "./Staking.sol";

contract RkDaiStaking is StakingRewards {

    constructor(address syncAddress, address rkdaiAddress, uint startDate) StakingRewards(syncAddress, rkdaiAddress, 21 days, startDate) public {}

}