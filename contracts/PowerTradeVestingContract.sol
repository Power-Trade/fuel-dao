pragma solidity ^0.5.16;

import "@openzeppelin/contracts/access/roles/WhitelistedRole.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Token.sol";
import "./VestingDepositAccount.sol";

//TODO admin ability to transfer locked tokens

contract PowerTradeVestingContract is WhitelistedRole, ReentrancyGuard {
    using SafeMath for uint256;

    event ScheduleCreated(
        address indexed _beneficiary,
        uint256 indexed _amount,
        uint256 indexed _start,
        uint256 _duration
    );

    event DrawDown(
        address indexed _beneficiary,
        uint256 indexed _amount,
        uint256 indexed _time
    );

    struct Schedule {
        uint256 start;
        uint256 end;
        uint256 cliffDurationBeforeStart;
        uint256 amount;
        uint256 totalDrawn;
        uint256 lastDrawnAt;
        uint256 drawDownRate;
        VestingDepositAccount depositAccount;
    }

    // Vested address to its schedule
    mapping(address => Schedule) public vestingSchedule;

    SyncToken public token;

    // All durations are based in number days
    uint256 public constant PERIOD_ONE_DAY_IN_SECONDS = 1 days;

    constructor(SyncToken _token) public {
        require(address(_token) != address(0));
        token = _token;
        super.addWhitelisted(msg.sender);//TODO move into its own contract
    }

    function createVestingSchedule(address _beneficiary, uint256 _amount, uint256 _start, uint256 _durationInDays, uint256 _cliffDurationBeforeStartInDays) onlyWhitelisted external returns (bool) {
        require(_beneficiary != address(0), "Beneficiary cannot be empty");
        require(_amount > 0, "Amount cannot be empty");
        require(_durationInDays > 0, "Duration cannot be empty");

        // Ensure one per address
        require(vestingSchedule[_beneficiary].amount == 0, "Schedule already in flight");

        // Set up the vesting deposit account for the _beneficiary
        address self = address(this);
        VestingDepositAccount depositAccount = new VestingDepositAccount(token, self, _beneficiary);

        // Create schedule
        uint256 _durationInSecs = _durationInDays.mul(PERIOD_ONE_DAY_IN_SECONDS);
        vestingSchedule[_beneficiary] = Schedule({
            start : _start,
            end : _start.add(_durationInSecs),
            cliffDurationBeforeStart : _cliffDurationBeforeStartInDays,
            amount : _amount,
            totalDrawn : 0, // no tokens drawn yet
            lastDrawnAt : 0, // never invoked
            drawDownRate : _amount.div(_durationInSecs),
            depositAccount : depositAccount
            });

        // Vest the tokens into the deposit account
        token.transferFrom(msg.sender, self, _amount);
        token.approve(address(depositAccount), _amount);
        depositAccount.deposit(self, _amount);

        emit ScheduleCreated(_beneficiary, _amount, _start, _durationInDays);

        return true;
    }

    function drawDown() nonReentrant external returns (bool) {
        Schedule storage schedule = vestingSchedule[msg.sender];
        require(schedule.amount > 0, "There is no schedule currently in flight");

        (uint256 amount,,) = _availableDrawDownAmount(msg.sender);
        require(amount > 0, "No allowance left to withdraw");

        // Update last drawn to now
        schedule.lastDrawnAt = _getNow();

        // Increase total drawn amount
        schedule.totalDrawn = schedule.totalDrawn.add(amount);

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
    returns (uint256 _start, uint256 _end, uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _drawDownRate, uint256 _remainingBalance) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return (
        schedule.start,
        schedule.end,
        schedule.amount,
        schedule.totalDrawn,
        schedule.lastDrawnAt,
        schedule.drawDownRate,
        schedule.amount.sub(schedule.totalDrawn)
        );
    }

    function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount, uint256 _timeLastDrawn, uint256 _drawDownRate) {
        return _availableDrawDownAmount(_beneficiary);
    }

    function scheduleStart(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].start;
    }

    function scheduleEnd(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].end;
    }

    function scheduleTotalTokens(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].amount;
    }

    function totalDrawn(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].totalDrawn;
    }

    function lastDrawnAt(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].lastDrawnAt;
    }

    function drawDownRate(address _beneficiary) external view returns (uint256) {
        return vestingSchedule[_beneficiary].drawDownRate;
    }

    function remainingBalance(address _beneficiary) external view returns (uint256) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return schedule.amount.sub(schedule.totalDrawn);
    }

    //////////////
    // Internal //
    //////////////

    function _getNow() internal view returns (uint256) {
        return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount, uint256 _timeLastDrawn, uint256 _drawDownRate) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        require(schedule.start <= _getNow(), "Schedule not started");

        ///////////////////////
        //TODO: Cliff Period //
        ///////////////////////

//        if (schedule.cliffDurationBeforeStart > 0) {
//
//        }

        ///////////////////////
        // Schedule complete //
        ///////////////////////

        if (_getNow() > schedule.end) {
            uint256 amount = schedule.amount.sub(schedule.totalDrawn);
            return (amount, schedule.lastDrawnAt, 0);
        }

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
        uint256 timeLastDrawn = schedule.lastDrawnAt == 0 ? schedule.start : schedule.lastDrawnAt;

        // Find out how much time has past since last invocation
        uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawn);

        // Work out how many due tokens - time passed * rate per second
        uint256 amount = timePassedSinceLastInvocation.mul(schedule.drawDownRate);

        return (amount, timeLastDrawn, schedule.drawDownRate);
    }
}
