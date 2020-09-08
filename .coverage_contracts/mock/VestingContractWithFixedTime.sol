// Used for testing

pragma solidity ^0.5.12;

import "../VestingContract.sol";

// THIS IS A MOCK TEST CONTRACT - DO NOT AUDIT OR DEPLOY!
contract VestingContractWithFixedTime is VestingContract {
function coverage_0xe4375940(bytes32 c__0xe4375940) public pure {}


    uint256 time;

    constructor(
        IERC20 _token,
        address _baseVestingDepositAccount,
        uint256 _start,
        uint256 _durationInSecs,
        uint256 _cliffDurationInSecs
    ) VestingContract(_token, _baseVestingDepositAccount, _start, _durationInSecs, _cliffDurationInSecs) public {coverage_0xe4375940(0xf2d9bcbd114fae49dc47811032ef6b6c6708a9adc67ff93f00c427fef04b582c); /* function */ 

        //
    }

    function fixTime(uint256 _time) external {coverage_0xe4375940(0x3dd5c4f78dce87ec1ada03e24a098d232afb6e59054766b1eee098c88667b9a4); /* function */ 

coverage_0xe4375940(0x5ed469572dd9beabe114f6fc75077b73df817de3fb43e5c137fb8310e8c2d592); /* line */ 
        coverage_0xe4375940(0xb5ecb2d6e89706fed845de5467773972313eec2b69c297f68e966a6ca3b083b1); /* statement */ 
time = _time;
    }

    function _getNow() internal view returns (uint256) {coverage_0xe4375940(0xd6d6b4f1df72a03c9661544849cb2a234ce4368a7789ee82469810a15ab762e9); /* function */ 

coverage_0xe4375940(0x5521bb7a24bafac5d7c1cb3b9b814f358dd2f3cb6a65bc991eda474b3af064f6); /* line */ 
        coverage_0xe4375940(0xeac2eaf582ffdc07159e3f3517acb2c29e4947d26d0c6836201c0186a08b5701); /* statement */ 
if (time != 0) {coverage_0xe4375940(0x7aa8bc734504476f64a160aa1b81b3e74e89c611f41b715e532f43f4cae05b3e); /* branch */ 

coverage_0xe4375940(0xf74c73c54d9971f3d241ba43281456ad6febeced636148fc6220a2eb5e08a8b4); /* line */ 
            coverage_0xe4375940(0x85ba83d7641be9418974ae6a73471095dc7827d73146ec79c0563de7fc1607b4); /* statement */ 
return time;
        }else { coverage_0xe4375940(0x61cd2f159c11746c3b59eae357a9fdcad77ae51cc33725cae5b55266dfedc79a); /* branch */ 
}
coverage_0xe4375940(0xd0fb61d7e419f177d476c5291f85cb3afe8ff5f72b18c2713577e4e14da5a744); /* line */ 
        coverage_0xe4375940(0x62d29d670875d22e099d58926355b530349fe61ce2bf486b4ef7931878a58db9); /* statement */ 
return block.timestamp;
    }

}
