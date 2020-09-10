pragma solidity ^0.5.16;

import "./SyncToken.sol";

contract VestingDepositAccount {
    address public controller;
    address public beneficiary;

    SyncToken public token;

    function init(address _tokenAddress, address _controller, address _beneficiary) external {
        require(controller == address(0), "VestingDepositAccount::init: Contract already initialized");
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

    function updateDelegation(address _delegatee) external {
        require(msg.sender == controller, "VestingDepositAccount::updateDelegation: Only controller");
        token.delegate(_delegatee);
    }
}