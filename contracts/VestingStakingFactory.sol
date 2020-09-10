pragma solidity ^0.5.16;

import "openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20.sol";
import "./Staking.sol";
import "./SyncToken.sol";

contract StakingToken is ERC20 {

    string public name;
    string public symbol;
    uint8 public constant decimals = 18;

    constructor(string memory _name, string memory _symbol, uint supply, address account) public {
        name = _name;
        symbol = _symbol;
        _mint(account, supply);
    }

}

contract VestingStakingFactory is Ownable {

    SyncToken public sync;

    constructor(address syncAddress) public {
        sync = SyncToken(syncAddress);
    }

    function createVestingContract(string memory stakingTokenName, string memory stakingTokenSymbol, uint amount, uint durationSeconds, uint startDate) public onlyOwner {
        // create token and give all tokens to msg.sender
        StakingToken stakingToken = new StakingToken(stakingTokenName, stakingTokenSymbol, amount, msg.sender);

        // create vesting contract
        StakingRewards stakingContract = new StakingRewards(address(sync), address(stakingToken), durationSeconds, startDate);

        // move sync tokens to vesting contract
        require(sync.transferFrom(msg.sender, address(stakingContract), amount));

        // emit addresses
        emit CreateVestingContract(address(stakingContract), address(stakingToken), amount, durationSeconds, startDate);
    }

    event CreateVestingContract(address stakingContract, address stakingToken, uint amount, uint durationSeconds, uint startDate);

}