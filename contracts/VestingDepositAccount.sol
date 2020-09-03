pragma solidity ^0.5.16;

import "./Token.sol";

contract VestingDepositAccount {
    address controller;
    address beneficiary;

    SyncToken public token;

    constructor(address _tokenAddress, address _controller, address _beneficiary) public {
        token = SyncToken(_tokenAddress);
        controller = _controller;
        beneficiary = _beneficiary;
    }

    function sendAllTokensBackToController() external {
        require(msg.sender == controller);
        uint256 controllerBalance = token.balanceOf(address(this));
        token.transfer(controller, controllerBalance);
    }

    function drawDown(uint256 _amount) external returns (bool) {
        require(msg.sender == controller);
        return token.transfer(beneficiary, _amount);
    }

    function updateVotingDelegation(address _delegatee) external {
        require(msg.sender == controller);
        token.delegate(_delegatee);
    }
}