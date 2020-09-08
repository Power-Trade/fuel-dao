pragma solidity ^0.5.16;

import "./SyncToken.sol";

contract VestingDepositAccount {
function coverage_0x5b6ee613(bytes32 c__0x5b6ee613) public pure {}

    address public controller;
    address public beneficiary;

    SyncToken public token;

    function init(address _tokenAddress, address _controller, address _beneficiary) external {coverage_0x5b6ee613(0x5defd5ccf0e7a587158474bbc47837a53d5d776de6b30fc0c9e83fe6ed6f9f27); /* function */ 

coverage_0x5b6ee613(0x16728088336c35b8d0f7fe852479d4c912be52b4def72204ee23aeffbef34e66); /* line */ 
        coverage_0x5b6ee613(0xd2b42bc8004d3e11f84f0d7b402fe3349403249522b79bab1898bfb4d121085d); /* assertPre */ 
coverage_0x5b6ee613(0x62b9e12139e83085b45da12d50bd40f9160909d34833a56ceee6ef8ab4695e82); /* statement */ 
require(controller == address(0), "VestingDepositAccount::init: Contract already initialized");coverage_0x5b6ee613(0x04a662b5bfabe2dda87e4431e2eab7d4ac4af63c68d9a78ad2139602cab2470f); /* assertPost */ 

coverage_0x5b6ee613(0x72eed98dd909e74df8780fae490189a0862d9457dd83a6afbc0f65d31aa48857); /* line */ 
        coverage_0x5b6ee613(0x26850a4d126ad0122464663ca43ca497773ce0c90b30f1576a7130fe4f714d7d); /* statement */ 
token = SyncToken(_tokenAddress);
coverage_0x5b6ee613(0xb1111d3aa27885e8f5e3979ca6046202a156d31ddeed33f6565fb3bd5f62b168); /* line */ 
        coverage_0x5b6ee613(0xcee7e15c80c96b2bb91014026718a926a65b7737a0bda8ec445593dd9f64c7aa); /* statement */ 
controller = _controller;
coverage_0x5b6ee613(0x21dc8efa5616f76dfac299f0e54130be555c4590f583d953534e0579bab58a1e); /* line */ 
        coverage_0x5b6ee613(0x2a947ae35b87e6cc9b0d42f8138192b8a9f40e518dc508664e23007ec0010a0c); /* statement */ 
beneficiary = _beneficiary;
    }

    function transferToBeneficiary(uint256 _amount) external returns (bool) {coverage_0x5b6ee613(0x6940795da0cabc4b73854d74574182270834ecb04ab87541cc95f32589a9617c); /* function */ 

coverage_0x5b6ee613(0xcd7f2f83ba3de511dd1487432b59c1c5b6255edb481f623144a18e3c194fd51b); /* line */ 
        coverage_0x5b6ee613(0x2eabbf7d93d79489af4f2055f119eb5d219d334e2f590e62c3c23400158670db); /* assertPre */ 
coverage_0x5b6ee613(0x3fbc5fb4b005beb6728b8f6b8f9272d5a81f80fa425f79591ea98e890c29c223); /* statement */ 
require(msg.sender == controller, "VestingDepositAccount::transferToBeneficiary: Only controller");coverage_0x5b6ee613(0x820e942a6b67e922eeea294e1083a308ce18848d296a76719ab388e95579de0e); /* assertPost */ 

coverage_0x5b6ee613(0x5ae1b01208bb1116f11fb81e4d3940e82df87dda3da0eafc4a9b4197937bd670); /* line */ 
        coverage_0x5b6ee613(0xf857a8c69ff7497726097acb9e4da049c9fd9b11512a636391a5ff2c064ae51f); /* statement */ 
return token.transfer(beneficiary, _amount);
    }

    function switchBeneficiary(address _newBeneficiary) external {coverage_0x5b6ee613(0x7758438b32e4bb6eef8c769d2858d4680d4b41e90af079b4698e65a6a3b710d0); /* function */ 

coverage_0x5b6ee613(0x41b5365a4650e4dc048b83488d3fbf0f6e320b71f68265f569771cc88a4640ad); /* line */ 
        coverage_0x5b6ee613(0x7cd18d1a0aa135eaa4edd740608590eed6874293f3eb93c37d5114c375b99917); /* assertPre */ 
coverage_0x5b6ee613(0x1716da19650f1c245af09e8df0835181e6f2ee53ad55689018f1e08fa6c73f36); /* statement */ 
require(msg.sender == controller, "VestingDepositAccount::switchBeneficiary: Only controller");coverage_0x5b6ee613(0xaafc026bf8ddfbb7ed47f844f0e98f2002ee6d7d4a3514cf23e21761652b28d3); /* assertPost */ 

coverage_0x5b6ee613(0xc9ac18dc20c3b65434c7648d9d079275972d9202cf34cf666822e540f5267ee2); /* line */ 
        coverage_0x5b6ee613(0x8605c8b556afb53ebcd13a6537b3b2910205836e4bd4db386bb9755c5ffe76b4); /* statement */ 
beneficiary = _newBeneficiary;
    }

    function updateVotingDelegation(address _delegatee) external {coverage_0x5b6ee613(0xe72eaf103e6e86399d507a5479efa2751fb5049d1f35a9e30f26662295ea9e83); /* function */ 

coverage_0x5b6ee613(0x5c7f82efed3086c02666d61d02894af4e276aee6fec966ed313a2e4eacae6aa8); /* line */ 
        coverage_0x5b6ee613(0x104bc0d845cc02ecc7d2c4947c245e6d85c0df50e68c1000935aa84c40311f70); /* assertPre */ 
coverage_0x5b6ee613(0x43bddfd8cdc54f95c8db22c74b5b5d86721d0f19828530250907bba879897964); /* statement */ 
require(msg.sender == controller, "VestingDepositAccount::updateVotingDelegation: Only controller");coverage_0x5b6ee613(0xf534ac3d5c6724a60c112cf3c801a33decfd3da6ccde243dca32681bea142ea5); /* assertPost */ 

coverage_0x5b6ee613(0x7c721dd0f67e0d254aad9875044a6eeac2a2d89237ac18387853fb90fb5e5b95); /* line */ 
        coverage_0x5b6ee613(0x3f2031042cdd3eac0c36c221e924dec35199d204028dde007cf20bb9de719f64); /* statement */ 
token.delegate(_delegatee);
    }
}