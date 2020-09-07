pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./CloneFactory.sol";
import "./IERC20.sol";
import "./VestingDepositAccount.sol";

contract VestingContract is CloneFactory, ReentrancyGuard {
    using SafeMath for uint256;

    event ScheduleCreated(address indexed _beneficiary, uint256 indexed _amount);

    event DrawDown(address indexed _beneficiary, uint256 indexed _amount, uint256 indexed _time);

    struct Schedule {
        uint256 end;
        uint256 amount;
        VestingDepositAccount depositAccount;
    }

    address public owner;

    // Vested address to its schedule
    mapping(address => Schedule) public vestingSchedule;
    mapping(address => uint256) public totalDrawn;
    mapping(address => uint256) public lastDrawnAt;

    IERC20 public token;

    address public baseVestingDepositAccount;

    uint256 public start;
    uint256 public durationInSecs;
    uint256 public cliffDuration;

    constructor(IERC20 _token, address _baseVestingDepositAccount) public {
        require(address(_token) != address(0));
        token = _token;
        owner = msg.sender;
        baseVestingDepositAccount = _baseVestingDepositAccount;
    }

    function init(uint256 _start, uint256 _durationInSecs, uint256 _cliffDurationInSecs) external {
        require(msg.sender == owner, "VestingContract::createVestingScheduleConfig: Only owner");
        require(_durationInSecs > 0, "VestingContract::createVestingScheduleConfig: Duration cannot be empty");

        start = _start;
        durationInSecs = _durationInSecs;
        cliffDuration = _cliffDurationInSecs;
    }

    function createVestingSchedule(address _beneficiary, uint256 _amount) external returns (bool) {
        require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");
        require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");

        require(start > 0, "VestingContract::createVestingSchedule: Schedule configuration does not exist");

        // Ensure one per address
        require(vestingSchedule[_beneficiary].amount == 0, "VestingContract::createVestingSchedule: Schedule already in flight");

        // Set up the vesting deposit account for the _beneficiary
        address depositAccountAddress = createClone(baseVestingDepositAccount);
        VestingDepositAccount depositAccount = VestingDepositAccount(depositAccountAddress);
        depositAccount.init(address(token), address(this), _beneficiary);

        // Create schedule
        uint256 end = start.add(durationInSecs);
        vestingSchedule[_beneficiary] = Schedule({
            end: end,
            amount : _amount,
            depositAccount : depositAccount
        });

        // Vest the tokens into the deposit account and delegate to the beneficiary
        require(token.transferFrom(msg.sender, address(depositAccount), _amount), "VestingContract::createVestingSchedule: Unable to transfer tokens to VDA");

        // ensure beneficiary has voting rights via delegate
        _updateVotingDelegation(_beneficiary);

        emit ScheduleCreated(_beneficiary, _amount);

        return true;
    }

    function drawDown() nonReentrant external returns (bool) {
        return _drawDown(msg.sender);
    }

    // transfer a schedule in tact to a new beneficiary (for pre-locked up schedules with no beneficiary)
    function updateScheduleBeneficiary(address _currentBeneficiary, address _newBeneficiary) external {
        require(msg.sender == owner, "VestingContract::updateScheduleBeneficiary: Only owner");
        _updateScheduleBeneficiary(_currentBeneficiary, _newBeneficiary);
    }

    ///////////////
    // Accessors //
    ///////////////

    // for a given beneficiary
    function tokenBalance() external view returns (uint256) {
        return token.balanceOf(address(vestingSchedule[msg.sender].depositAccount));
    }

    function depositAccountAddress() external view returns (address) {
        Schedule memory schedule = vestingSchedule[msg.sender];
        return address(schedule.depositAccount);
    }

    function vestingScheduleForBeneficiary(address _beneficiary)
    external view
    returns (uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _drawDownRate, uint256 _remainingBalance) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return (
        schedule.amount,
        totalDrawn[_beneficiary],
        lastDrawnAt[_beneficiary],
        schedule.amount.div(schedule.end.sub(start)),
        schedule.amount.sub(totalDrawn[_beneficiary])
        );
    }

    function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount, uint256 _timeLastDrawn, uint256 _drawDownRate) {
        return _availableDrawDownAmount(_beneficiary);
    }

    function remainingBalance(address _beneficiary) external view returns (uint256) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return schedule.amount.sub(totalDrawn[_beneficiary]);
    }

    //////////////
    // Internal //
    //////////////
    function _drawDown(address _beneficiary) internal returns (bool) {
        Schedule storage schedule = vestingSchedule[_beneficiary];
        require(schedule.amount > 0, "VestingContract::_drawDown: There is no schedule currently in flight");

        (uint256 amount,,) = _availableDrawDownAmount(_beneficiary);
        require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");

        // Update last drawn to now
        lastDrawnAt[_beneficiary] = _getNow();

        // Increase total drawn amount
        totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);

        // Issue tokens to beneficiary
        require(schedule.depositAccount.transferToBeneficiary(amount), "VestingContract::_drawDown: Unable to transfer tokens");

        emit DrawDown(_beneficiary, amount, _getNow());

        return true;
    }

    function _updateScheduleBeneficiary(address _currentBeneficiary, address _newBeneficiary) internal {
        // retrieve existing schedule
        Schedule storage schedule = vestingSchedule[_currentBeneficiary];
        require(schedule.amount > 0, "VestingContract::_updateScheduleBeneficiary: No schedule exists for current beneficiary");

        require(_drawDown(_currentBeneficiary), "VestingContract::_updateScheduleBeneficiary: Unable to drawn down");

        // transfer the schedule to the new beneficiary
        vestingSchedule[_newBeneficiary] = Schedule({
            end: schedule.end,
            amount: schedule.amount.sub(totalDrawn[_currentBeneficiary]),
            depositAccount: schedule.depositAccount
        });

        vestingSchedule[_newBeneficiary].depositAccount.switchBeneficiary(_newBeneficiary);

        // close down the old schedule by setting amount to drawn and ending
        schedule.amount = totalDrawn[_currentBeneficiary];
        schedule.end = _getNow();
    }

    // note only the beneficiary associated with a vesting schedule can claim voting rights
    function _updateVotingDelegation(address _delegatee) internal {
        Schedule storage schedule = vestingSchedule[_delegatee];
        require(schedule.amount > 0, "VestingContract::_updateVotingDelegation: There is no schedule currently in flight");
        schedule.depositAccount.updateVotingDelegation(_delegatee);
    }

    function _getNow() internal view returns (uint256) {
        return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount, uint256 _timeLastDrawn, uint256 _drawDownRate) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        require(start <= _getNow(), "VestingContract::_availableDrawDownAmount: Schedule not started");

        ///////////////////////
        // Cliff Period      //
        ///////////////////////

        if (_getNow() < start.add(cliffDuration)) {
            // the cliff period has not ended, no tokens to draw down
            return (0, lastDrawnAt[_beneficiary], 0);
        }

        ///////////////////////
        // Schedule complete //
        ///////////////////////

        if (_getNow() > schedule.end) {
            uint256 amount = schedule.amount.sub(totalDrawn[_beneficiary]);
            return (amount, lastDrawnAt[_beneficiary], 0);
        }

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
        uint256 timeLastDrawn = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];

        // Find out how much time has past since last invocation
        uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawn);

        // Work out how many due tokens - time passed * rate per second
        uint256 drawDownRate = schedule.amount.div(schedule.end.sub(start));
        uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);

        require(amount <= schedule.amount.sub(totalDrawn[_beneficiary]), "VestingContract::_availableDrawDownAmount: Sanity check");

        return (amount, timeLastDrawn, drawDownRate);
    }
}
