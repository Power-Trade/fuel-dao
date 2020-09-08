// Used for testing

pragma solidity ^0.5.12;

import "../VestingContractWithoutDelegation.sol";

// THIS IS A MOCK TEST CONTRACT - DO NOT AUDIT OR DEPLOY!
contract VestingContractWithoutDelegationFixedTime is VestingContractWithoutDelegation {
function coverage_0x497d91ae(bytes32 c__0x497d91ae) public pure {}


    uint256 time;

    constructor(IERC20 _token, uint256 _start, uint256 _end, uint256 _cliffDuration) VestingContractWithoutDelegation(_token, _start, _end, _cliffDuration) public {coverage_0x497d91ae(0xc75230b462f0e753ff940c7369384962e99c6669558e1b82f8cfbae7159295c0); /* function */ 

        //
    }

    function fixTime(uint256 _time) external {coverage_0x497d91ae(0x87468f0c662a0dd3ad45753e327c1c37d91cc71475f862d547d5ec12d590b040); /* function */ 

coverage_0x497d91ae(0xbacfba80878868983d9d71e410bfa9055a783314ca81cf9a49c1e2445dd25f95); /* line */ 
        coverage_0x497d91ae(0x1d04cb5c43ac215335def0a2c0247d79504e77ff3db3c3dd2ad48410d255f0e4); /* statement */ 
time = _time;
    }

    function _getNow() internal view returns (uint256) {coverage_0x497d91ae(0x1a967d4368510de8214094f6bfd79440afc5540413810a2a9f02752284b03c18); /* function */ 

coverage_0x497d91ae(0x1db1677218ea0c7dcf52ca09966adf5bb2967c9e8fe4a8700ea16687044772ab); /* line */ 
        coverage_0x497d91ae(0x55176c15a8587e7e7e724c5445eae67455291f09b15c7b52d249a45dbdd11adc); /* statement */ 
if (time != 0) {coverage_0x497d91ae(0xca1fd1a0503ef161f43738bda6c6774005bcb3caef41e05f40df017d35409394); /* branch */ 

coverage_0x497d91ae(0xb0cbd1f1fb686947bf6c8e9dcc1713b357fdf4658e1261d511afc15ffb593707); /* line */ 
            coverage_0x497d91ae(0xaf259483e7c3d5bfccfd7cf1b975235f69963730f43cfb7393f9b478fb690fed); /* statement */ 
return time;
        }else { coverage_0x497d91ae(0xf3af084c3628ed481e473ee69d697a88f0d613d4950749a91332a434f5277e83); /* branch */ 
}
coverage_0x497d91ae(0x544fca8eb37eaebef161bcb5d24705ddd670fb30618f553bace1e5a228cac67b); /* line */ 
        coverage_0x497d91ae(0x82621d5f4cd6fbb673e607b36da118129fb823aeb670b3c34e0f6a381d94da60); /* statement */ 
return block.timestamp;
    }

}
