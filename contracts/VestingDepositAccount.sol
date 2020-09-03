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

    function drawDown(uint256 _amount) external returns (bool) {
        require(msg.sender == controller, "Only the account controller can call drawDown()");
        return token.transfer(beneficiary, _amount);
    }

    function updateVotingDelegation(address _delegatee) external {
        require(msg.sender == controller, "Only the account controller can call updateVotingDelegation()");
        token.delegate(_delegatee);
    }
}