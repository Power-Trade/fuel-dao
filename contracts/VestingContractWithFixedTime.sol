// Used for testing

pragma solidity ^0.5.12;

import "./PowerTradeVestingContract.sol";

contract VestingContractWithFixedTime is PowerTradeVestingContract {

    uint256 time;

    constructor(SyncToken _token) PowerTradeVestingContract(_token) public {
        //
    }

    function fixTime(uint256 _time) external {
        time = _time;
    }

    function _getNow() internal view returns (uint256) {
        if (time != 0) {
            return time;
        }
        return block.timestamp;
    }

}
