pragma solidity ^0.5.16;

import "./Token.sol";

contract VestingDepositAccount {
    address controller;
    address beneficiary;

    SyncToken public token;

    constructor(SyncToken _token, address _controller, address _beneficiary) public {
        token = _token;
        controller = _controller;
        beneficiary = _beneficiary;
    }

    function deposit(address _from, uint256 _amount) external {
        require(msg.sender == controller);
        address self = address(this);
        require(token.transferFrom(_from, self, _amount), "Unable to transfer tokens to vesting deposit contract");

        // Delegate all token voting power in this deposit account to the _beneficiary schedule
        token.delegate(beneficiary);
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