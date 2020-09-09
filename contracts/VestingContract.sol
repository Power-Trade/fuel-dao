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
        uint256 amount;
        VestingDepositAccount depositAccount;
    }

    address public owner;

    // Vested address to its schedule
    mapping(address => Schedule) public vestingSchedule;

    // Vested address to total tokens drawn down
    mapping(address => uint256) public totalDrawn;

    // Vested address to last drawn down time (seconds)
    mapping(address => uint256) public lastDrawnAt;

    // when updating beneficiary void the old schedule
    mapping(address => bool) public voided;

    IERC20 public token;

    address public baseVestingDepositAccount;

    uint256 public start;
    uint256 public end;
    uint256 public cliffDuration;

    constructor(
        IERC20 _token,
        address _baseVestingDepositAccount,
        uint256 _start,
        uint256 _end,
        uint256 _cliffDurationInSecs
    ) public {
        require(address(_token) != address(0), "VestingContract::constructor: Invalid token");
        require(_end >= _start, "VestingContract::constructor: Start must be before end");

        token = _token;
        owner = msg.sender;
        baseVestingDepositAccount = _baseVestingDepositAccount;

        start = _start;
        end = _end;
        cliffDuration = _cliffDurationInSecs;
    }

    function createVestingSchedule(address _beneficiary, uint256 _amount) external returns (bool) {
        require(msg.sender == owner, "VestingContract::createVestingSchedule: Only Owner");
        require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");
        require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");

        // Ensure one per address
        require(
            vestingSchedule[_beneficiary].amount == 0, 
            "VestingContract::createVestingSchedule: Schedule already in flight"
        );

        // Set up the vesting deposit account for the _beneficiary
        address depositAccountAddress = createClone(baseVestingDepositAccount);
        VestingDepositAccount depositAccount = VestingDepositAccount(depositAccountAddress);
        depositAccount.init(address(token), address(this), _beneficiary);

        // Create schedule
        vestingSchedule[_beneficiary] = Schedule({
            amount : _amount,
            depositAccount : depositAccount
        });

        // Vest the tokens into the deposit account and delegate to the beneficiary
        require(
            token.transferFrom(msg.sender, address(depositAccount), _amount),
            "VestingContract::createVestingSchedule: Unable to transfer tokens to VDA"
        );

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

        // retrieve existing schedule
        Schedule memory schedule = vestingSchedule[_currentBeneficiary];
        require(_drawDown(_currentBeneficiary), "VestingContract::_updateScheduleBeneficiary: Unable to drawn down");

        // the old schedule is now void
        voided[_currentBeneficiary] = true;

        // setup new schedule with the amount left after the previous beneficiary's draw down
        vestingSchedule[_newBeneficiary] = Schedule({
            amount : schedule.amount.sub(totalDrawn[_currentBeneficiary]),
            depositAccount : schedule.depositAccount
        });

        vestingSchedule[_newBeneficiary].depositAccount.switchBeneficiary(_newBeneficiary);

        // ensure the new beneficiary has delegate rights
        _updateVotingDelegation(_newBeneficiary);
    }

    ///////////////
    // Accessors //
    ///////////////

    // for a given beneficiary
    function tokenBalance() external view returns (uint256) {
        return token.balanceOf(address(vestingSchedule[msg.sender].depositAccount));
    }

    function vestingScheduleForBeneficiary(address _beneficiary)
    external view
    returns (
        uint256 _amount,
        uint256 _totalDrawn,
        uint256 _lastDrawnAt,
        uint256 _drawDownRate,
        uint256 _remainingBalance,
        address _depositAccountAddress
    ) {
        Schedule memory schedule = vestingSchedule[_beneficiary];
        return (
        schedule.amount,
        totalDrawn[_beneficiary],
        lastDrawnAt[_beneficiary],
        schedule.amount.div(end.sub(start)),
        schedule.amount.sub(totalDrawn[_beneficiary]),
        address(schedule.depositAccount)
        );
    }

    function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount) {
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
        Schedule memory schedule = vestingSchedule[_beneficiary];
        require(schedule.amount > 0, "VestingContract::_drawDown: There is no schedule currently in flight");

        uint256 amount = _availableDrawDownAmount(_beneficiary);
        require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");

        // Update last drawn to now
        lastDrawnAt[_beneficiary] = _getNow();

        // Increase total drawn amount
        totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);

        // Safety measure - this should never trigger
        require(
            totalDrawn[_beneficiary] <= schedule.amount, 
            "VestingContract::_drawDown: Safety Mechanism - Drawn exceeded Amount Vested"
        );

        // Issue tokens to beneficiary
        require(
            schedule.depositAccount.transferToBeneficiary(amount), 
            "VestingContract::_drawDown: Unable to transfer tokens"
        );

        emit DrawDown(_beneficiary, amount, _getNow());

        return true;
    }

    // note only the beneficiary associated with a vesting schedule can claim voting rights
    function _updateVotingDelegation(address _delegatee) internal {
        Schedule memory schedule = vestingSchedule[_delegatee];
        
        require(
            schedule.amount > 0,
            "VestingContract::_updateVotingDelegation: There is no schedule currently in flight"
        );

        schedule.depositAccount.updateVotingDelegation(_delegatee);
    }

    function _getNow() internal view returns (uint256) {
        return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount) {
        Schedule memory schedule = vestingSchedule[_beneficiary];

        // voided contract should not allow any drawdowns
        if (voided[_beneficiary]) {
            return 0;
        }

        // cliff
        if (_getNow() < start.add(cliffDuration)) {
            // the cliff period has not ended, no tokens to draw down
            return 0;
        }

        // schedule complete
        if (_getNow() > end) {
            return schedule.amount.sub(totalDrawn[_beneficiary]);
        }

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
        uint256 timeLastDrawnOrStart = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];

        // Find out how much time has past since last invocation
        uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawnOrStart);

        // Work out how many due tokens - time passed * rate per second
        uint256 drawDownRate = schedule.amount.div(end.sub(start));
        uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);

        return amount;
    }
}
