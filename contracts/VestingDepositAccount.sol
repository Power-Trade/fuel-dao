pragma solidity ^0.5.16;

import "./SyncToken.sol";

contract VestingDepositAccount {
    address public controller;
    address public beneficiary;

    SyncToken public token;

    constructor(address _tokenAddress, address _controller, address _beneficiary) public {
        token = SyncToken(_tokenAddress);
        controller = _controller;
        beneficiary = _beneficiary;
    }

    function transferToBeneficiary(uint256 _amount) external returns (bool) {
        require(msg.sender == controller, "VestingDepositAccount::transferToBeneficiary: Only controller");
        return token.transfer(beneficiary, _amount);
    }

    function switchBeneficiary(address _newBeneficiary) external {
        require(msg.sender == controller, "VestingDepositAccount::switchBeneficiary: Only controller");
        beneficiary = _newBeneficiary;
    }

    function updateVotingDelegation(address _delegatee) external {
        require(msg.sender == controller, "VestingDepositAccount::updateVotingDelegation: Only controller");
        token.delegate(_delegatee);
    }
}