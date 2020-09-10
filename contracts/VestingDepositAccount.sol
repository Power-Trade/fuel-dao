pragma solidity ^0.5.16;

import "./SyncToken.sol";

/// @author BlockRocket
contract VestingDepositAccount {

    /// @notice the controlling parent vesting contract
    address public controller;

    /// @notice beneficiary who tokens will be transferred to
    address public beneficiary;

    /// @notice ERC20 token that is vested (extended with a delegate function)
    SyncToken public token;

    /**
     * @notice Using a minimal proxy contract pattern initialises the contract
     * @dev initialises the VestingDepositAccount (see https://eips.ethereum.org/EIPS/eip-1167)
     * @dev only controller
     */
    function init(address _tokenAddress, address _controller, address _beneficiary) external {
        require(controller == address(0), "VestingDepositAccount::init: Contract already initialized");
        token = SyncToken(_tokenAddress);
        controller = _controller;
        beneficiary = _beneficiary;
    }

    /**
     * @notice Transfer tokens vested in the VestingDepositAccount to the beneficiary
     * @param _amount amount of tokens (in wei)
     * @dev only controller
     */
    function transferToBeneficiary(uint256 _amount) external returns (bool) {
        require(msg.sender == controller, "VestingDepositAccount::transferToBeneficiary: Only controller");
        return token.transfer(beneficiary, _amount);
    }

    /**
     * @notice Allows the beneficiary to be switched on the VestingDepositAccount
     * @param _newBeneficiary address to receive tokens once switched
     * @dev only controller
     */
    function switchBeneficiary(address _newBeneficiary) external {
        require(msg.sender == controller, "VestingDepositAccount::switchBeneficiary: Only controller");
        beneficiary = _newBeneficiary;
    }

    /**
     * @notice Proxies to the ERC20 token to set delegation rights
     * @dev only controller
     */
    function updateDelegation() external {
        require(msg.sender == controller, "VestingDepositAccount::updateDelegation: Only controller");
        token.delegate(beneficiary);
    }
}