// Used for testing

pragma solidity ^0.5.12;

import "./VestingContract.sol";

// THIS IS A MOCK TEST CONTRACT - DO NOT AUDIT OR DEPLOY!
contract VestingContractWithFixedTime is VestingContract {

    uint256 time;

    constructor(IERC20 _token) VestingContract(_token) public {
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
