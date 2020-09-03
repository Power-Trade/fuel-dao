pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IERC20.sol";
import "./VestingDepositAccount.sol";

//TODO admin ability to transfer locked tokens

contract PowerTradeVestingContract is ReentrancyGuard {
    using SafeMath for uint256;

    event ScheduleCreated(
        address indexed _beneficiary,
        uint256 indexed _amount
    );

    event DrawDown(
        address indexed _beneficiary,
        uint256 indexed _amount,
        uint256 indexed _time
    );

    struct ScheduleConfig {
        uint256 start;
        uint256 end;
        uint256 cliffDurationBeforeStart;
    }

    struct Schedule {
        string scheduleConfigId;
        uint256 amount;
        uint256 drawDownRate;
        VestingDepositAccount depositAccount;
    }

    address owner;

    // Vested address to its schedule
    mapping(string => ScheduleConfig) public vestingScheduleConfigs;
    mapping(address => Schedule) public vestingSchedule;
    mapping(address => uint256) public totalDrawn;
    mapping(address => uint256) public lastDrawnAt;

    IERC20 public token;

    // All durations are based in number days
    uint256 public constant PERIOD_ONE_DAY_IN_SECONDS = 1 days;

    constructor(IERC20 _token) public {
        require(address(_token) != address(0));
        token = _token;
        owner = msg.sender;
    }

    function createVestingScheduleConfig(string calldata _scheduleConfigId, uint256 _start, uint256 _durationInDays, uint256 _cliffDurationBeforeStartInDays) external {
        require(msg.sender == owner, "Only the owner can set up schedule configs");
        require(_durationInDays > 0, "Duration cannot be empty");
        uint256 _durationInSecs = _durationInDays.mul(PERIOD_ONE_DAY_IN_SECONDS);
        uint256 _cliffDurationInSecs = _cliffDurationBeforeStartInDays.mul(PERIOD_ONE_DAY_IN_SECONDS);
        vestingScheduleConfigs[_scheduleConfigId] = ScheduleConfig({
            start: _start,
            end: _start.add(_durationInSecs),
            cliffDurationBeforeStart: _cliffDurationInSecs
        });
    }

    function createVestingSchedule(string calldata _scheduleConfigId, address _beneficiary, uint256 _amount) external returns (bool) {
        require(_beneficiary != address(0), "Beneficiary cannot be empty");
        require(_amount > 0, "Amount cannot be empty");

        ScheduleConfig memory scheduleConfig = vestingScheduleConfigs[_scheduleConfigId];
        require(scheduleConfig.start > 0, "References schedule configuration does not exist");

        // Ensure one per address
        require(vestingSchedule[_beneficiary].amount == 0, "Schedule already in flight");

        // Set up the vesting deposit account for the _beneficiary
        address self = address(this);
        VestingDepositAccount depositAccount = new VestingDepositAccount(address(token), self, _beneficiary);

        // Create schedule
        vestingSchedule[_beneficiary] = Schedule({
            scheduleConfigId: _scheduleConfigId,
            amount : _amount,
            drawDownRate : _amount.div(scheduleConfig.end.sub(scheduleConfig.start)),
            depositAccount : depositAccount
        });

        // Vest the tokens into the deposit account and delegate to the beneficiary
        require(token.transferFrom(msg.sender, address(depositAccount), _amount), "Unable to transfer tokens to vesting deposit contract");

        emit ScheduleCreated(_beneficiary, _amount);

        return true;
    }

    function drawDown() nonReentrant external returns (bool) {
        Schedule storage schedule = vestingSchedule[msg.sender];
        require(schedule.amount > 0, "There is no schedule currently in flight");

        (uint256 amount,,) = _availableDrawDownAmount(msg.sender);
        require(amount > 0, "No allowance left to withdraw");

        // Update last drawn to now
        lastDrawnAt[msg.sender] = _getNow();

        // Increase total drawn amount
        totalDrawn[msg.sender] = totalDrawn[msg.sender].add(amount);

        // Issue tokens to beneficiary
        require(schedule.depositAccount.drawDown(amount), "Unable to transfer tokens");

        emit DrawDown(msg.sender, amount, _getNow());

        return true;
    }

    function updateVotingDelegation(address _delegatee) external {
        Schedule storage schedule = vestingSchedule[msg.sender];
        require(schedule.amount > 0, "There is no schedule currently in flight");
        schedule.depositAccount.updateVotingDelegation(_delegatee);
    }

    ///////////////
    // Accessors //
    ///////////////

    // for a given beneficiary
    function tokenBalance() public view returns (uint256) {
        return token.balanceOf(depositAccountAddress());
    }

    function depositAccountAddress() public view returns (address) {
        Schedule memory schedule = vestingSchedule[msg.sender];
        return address(schedule.depositAccount);
    }

    function vestingScheduleForBeneficiary(address _beneficiary)
    external view
    returns (string memory _scheduleConfigId, uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _drawDownRate, uint256 _remainingBalance) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return (
        schedule.scheduleConfigId,
        schedule.amount,
        totalDrawn[_beneficiary],
        lastDrawnAt[_beneficiary],
        schedule.drawDownRate,
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

    function _getNow() internal view returns (uint256) {
        return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount, uint256 _timeLastDrawn, uint256 _drawDownRate) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        ScheduleConfig memory scheduleConfig = vestingScheduleConfigs[schedule.scheduleConfigId];
        require(scheduleConfig.start <= _getNow(), "Schedule not started");

        ///////////////////////
        //TODO: Cliff Period //
        ///////////////////////

//        if (schedule.cliffDurationBeforeStart > 0) {
//
//        }

        ///////////////////////
        // Schedule complete //
        ///////////////////////

        if (_getNow() > scheduleConfig.end) {
            uint256 amount = schedule.amount.sub(totalDrawn[_beneficiary]);
            return (amount, lastDrawnAt[_beneficiary], 0);
        }

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
        uint256 timeLastDrawn = lastDrawnAt[_beneficiary] == 0 ? scheduleConfig.start : lastDrawnAt[_beneficiary];

        // Find out how much time has past since last invocation
        uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawn);

        // Work out how many due tokens - time passed * rate per second
        uint256 amount = timePassedSinceLastInvocation.mul(schedule.drawDownRate);

        return (amount, timeLastDrawn, schedule.drawDownRate);
    }
}
