pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./CloneFactory.sol";
import "./IERC20.sol";
import "./VestingDepositAccount.sol";

contract VestingContract is CloneFactory, ReentrancyGuard {
function coverage_0x09f75103(bytes32 c__0x09f75103) public pure {}

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
    ) public {coverage_0x09f75103(0xa4d35d188f63bd9b80be9309596cfe76dc6f02238a74a5b7198b5e662e7073fe); /* function */ 

coverage_0x09f75103(0x1e3d47afecf3cd122a0db65cafa8a93e5da0694611a25ba10562946667de069c); /* line */ 
        coverage_0x09f75103(0x89210afca0ae5206a8ef19fc42e7d4a628024c4b0754899b81d45a856e90cf50); /* assertPre */ 
coverage_0x09f75103(0xbf40759a8bbb874476aff55267da624560ac38fc10028c75c50c08e1c34fe81c); /* statement */ 
require(address(_token) != address(0));coverage_0x09f75103(0x2a361f022e0935b1a83b6ac38ed9fe4a70b2f3337e86fffa6f41773dd4780809); /* assertPost */ 

coverage_0x09f75103(0xbcdc41889b2ef590ad8053cfe1b86e8b0df1742a0bcfc2b3cbc4fdba1afb2397); /* line */ 
        coverage_0x09f75103(0x54976acc7996b211c8f003a6c590262c7ea9e08700dc81e4f360b41431f746f3); /* assertPre */ 
coverage_0x09f75103(0x073648022c24dc8d81a6d1e1ed024b86a004788ac190ef25bb53e0f5dda9c1fd); /* statement */ 
require(end >= start, "VestingContract::constructor: Start must be before end");coverage_0x09f75103(0xe2c663b0d436b9343371a92bed7c3f0b01baceb15f3d7b827583b3420f9476f7); /* assertPost */ 


coverage_0x09f75103(0xe25f54e0564197a90ee2ad5661d58bfc9fb2de5f39e75afeb4596a8a7549e974); /* line */ 
        coverage_0x09f75103(0x6cbb6c057a1b36be921ff68a11d195d821fbfa95e0fefb8a695160ddf6687cfc); /* statement */ 
token = _token;
coverage_0x09f75103(0xaeb00a5c5cc2a9714a10430ee2bddc6e43fd6168e5c9b19e605f8bd1d3dfc608); /* line */ 
        coverage_0x09f75103(0x7888b10b44a69983a81f8a7a66cb02b7de2bb506bd3045936331b16b53b20488); /* statement */ 
owner = msg.sender;
coverage_0x09f75103(0x4e5a28c11cb0150462bac95670b5f5ef1cb9d7814542853cbd00f4b52f4b7262); /* line */ 
        coverage_0x09f75103(0xe267cbdc7c62d54a5f8c8f593f738811ffd652b55621b6370f9b413863f08ca0); /* statement */ 
baseVestingDepositAccount = _baseVestingDepositAccount;

coverage_0x09f75103(0xcdacaaa5f3a1eac0c5924c001523a0a1c9943489e15d2c57eb6d2b4b164aabbe); /* line */ 
        coverage_0x09f75103(0x8d989605ad7920bf548b428e6f9d89304c8d5075d5b38abac825860075355623); /* statement */ 
start = _start;
coverage_0x09f75103(0xd0f38f0d22d0e64051446c37d3b7a91213fc84c89f14e6be6f73412dadaa9744); /* line */ 
        coverage_0x09f75103(0x2607daa38c80cf15f84869841e7cf88617b41b37e352bad4d50a3241527683a0); /* statement */ 
end = _end;
coverage_0x09f75103(0x477b87623ce3d0f4e0471c2e4d9aa08d345699534e1e682cb79264e3565ae338); /* line */ 
        coverage_0x09f75103(0xed5defdb560f260e72220517f84f9ae42065191d732bb9e216a16af690a2aeb6); /* statement */ 
cliffDuration = _cliffDurationInSecs;
    }

    function createVestingSchedule(address _beneficiary, uint256 _amount) nonReentrant external returns (bool) {coverage_0x09f75103(0x35da08ece9defbc80d40402fd32320b13b0d4a46f324efb3c33923f6d5c802c9); /* function */ 

coverage_0x09f75103(0xcad3fa0202c52c3eae9c9e778199be514fb5ff99027b1337bd1bd146e03b6bce); /* line */ 
        coverage_0x09f75103(0xf2374a368b3c78bd6376db53707a3a87e5959868b6d2ba13ce29cc4b3e94089f); /* assertPre */ 
coverage_0x09f75103(0xfb46dd719798a9900ccd1914af6d82f2cd8963ddc161d714cc4f73aff3df08d0); /* statement */ 
require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");coverage_0x09f75103(0xbf2e09692859bfe072805e874316c8bf7d5d30c6f0d11f3aeef067fde5b2d8ef); /* assertPost */ 

coverage_0x09f75103(0x364ebad0cef170feb48418f32d3ff17b4784e6294faac112c6366d8fcbe54777); /* line */ 
        coverage_0x09f75103(0x3c8d111b2d074ed5849ab65ff7508d99cfa4f19c46cabe002bd4aa14473d8185); /* assertPre */ 
coverage_0x09f75103(0x1a78860a17f340d12aef042cbd52c7ecf35f1aba1f4377c695f66d65731274d1); /* statement */ 
require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");coverage_0x09f75103(0xd4985700d8266cb35ddca7479de0af7c3bde8914d29162d1ca036ab045dc3eb4); /* assertPost */ 


        // Ensure one per address
coverage_0x09f75103(0x443742ab627e7c821ecf79930fe733aa4bd67e376100ac7eeeed30750a46f106); /* line */ 
        coverage_0x09f75103(0x062c975cb164391418c2f9a280467344851925b6b7ff30ee229a1a618ec2bd02); /* assertPre */ 
coverage_0x09f75103(0x57b5883c63eaf6a601053c17a5e088fcca641285147aad43a7d3e2e70753d2e9); /* statement */ 
require(vestingSchedule[_beneficiary].amount == 0, "VestingContract::createVestingSchedule: Schedule already in flight");coverage_0x09f75103(0x1186d3ce49928c94297e19275b09b497ef7638c9135a03e78472b43ca259a1f4); /* assertPost */ 


        // Set up the vesting deposit account for the _beneficiary
coverage_0x09f75103(0xd832e2aaf755fd53e6842078980bf90918c3d9048dff0d9a61780b6d5c4017c8); /* line */ 
        coverage_0x09f75103(0x069bda013ee9a59b083fb589ec2aed336b32168e2562e274f9b6d23cea3b8170); /* statement */ 
address depositAccountAddress = createClone(baseVestingDepositAccount);
coverage_0x09f75103(0x72df5d54fffa8f330704aba75953d48b0023197b2665cbb425e577542f7379b7); /* line */ 
        coverage_0x09f75103(0x514791a09a70b1b126b18dd2ebdcea2af60ba0d07a2551ab5c8b030278b18c74); /* statement */ 
VestingDepositAccount depositAccount = VestingDepositAccount(depositAccountAddress);
coverage_0x09f75103(0x07cf4ae41f3153946f27b546fc497a096e870a4c3543a327ba4de4fd6a10c3a6); /* line */ 
        coverage_0x09f75103(0xe6208f55adcb17ed9269ed0fdf30d197a13377c35a6bd81c7a40e355c093517c); /* statement */ 
depositAccount.init(address(token), address(this), _beneficiary);

        // Create schedule
coverage_0x09f75103(0x2b922794057a82ff290bbbc198dae0dafd2ed6071d339c1954552fc1844cc8ae); /* line */ 
        coverage_0x09f75103(0xe1aa47eb926b5d30d9c2951c814a6a4e33ec946bc905aa211323b6df1d3342df); /* statement */ 
vestingSchedule[_beneficiary] = Schedule({
            amount : _amount,
            depositAccount : depositAccount
            });

        // Vest the tokens into the deposit account and delegate to the beneficiary
coverage_0x09f75103(0x4b2d9d8349834a5cec1170c3d3f4fe38d78ffd8b6f6bf49e205381f600295e65); /* line */ 
        coverage_0x09f75103(0xe96183c8c0bed283b42e2590faae7301d26aae5078c79713e62c3f153f13ec69); /* assertPre */ 
coverage_0x09f75103(0xbbae99a753d21812fb57b0f2abbc2d730295e26f89705fdbb738de6f7ff391ee); /* statement */ 
require(token.transferFrom(msg.sender, address(depositAccount), _amount), "VestingContract::createVestingSchedule: Unable to transfer tokens to VDA");coverage_0x09f75103(0x57589dd7337f5afa2b41e7ab7f67fcc2efa10acc6c3d88afb2fc94e530d49e22); /* assertPost */ 


        // ensure beneficiary has voting rights via delegate
coverage_0x09f75103(0x647387642dfb7b37eae5e1e58b596ef6e5c99843a18346a339381731c0618a2c); /* line */ 
        coverage_0x09f75103(0xc1a3059150c5018d9db56444541788f03b9b7784622ac1674890eb91414a3e3b); /* statement */ 
_updateVotingDelegation(_beneficiary);

coverage_0x09f75103(0xed3c52a7f48728b1e2c2c6b1071a73677ce65102d28efcb08c10e276e97225d4); /* line */ 
        coverage_0x09f75103(0x65fb23a3201e05ab6c3a518fa0b99c475a15f81134a2b9c53642ca4632fcd516); /* statement */ 
emit ScheduleCreated(_beneficiary, _amount);

coverage_0x09f75103(0x90fecbee37bd59071b0dc6b03e352e0a411c90533db62cb4555ee5c9479aa1c3); /* line */ 
        coverage_0x09f75103(0xed482b8272241e587903ca98e4d11f35adbd388ea6a60302ae4e2a276b55fdcf); /* statement */ 
return true;
    }

    function drawDown() nonReentrant external returns (bool) {coverage_0x09f75103(0x0e18d5d3dd9a6c2ea63c93d964c80dae038d1fcd0049fef24d49e40b0008b7a6); /* function */ 

coverage_0x09f75103(0x02e80d787dc666a0f7ac9613c86b1cfb6be7affebea02d185564689f8b40de23); /* line */ 
        coverage_0x09f75103(0x9420adb93eb6f0cc185b5ec50d8c4afc5ef98b7f5ca3557ea98ea8516e978981); /* statement */ 
return _drawDown(msg.sender);
    }

    // transfer a schedule in tact to a new beneficiary (for pre-locked up schedules with no beneficiary)
    function updateScheduleBeneficiary(address _currentBeneficiary, address _newBeneficiary) external {coverage_0x09f75103(0x7daa0d70c27754b3ee6b78c6e19d32d2fa974f9397beac651329a784bfa14240); /* function */ 

coverage_0x09f75103(0xd8dd493b6acefa9e413948b609162bcd7d8c815f9b6750ab3ddc436bb2f75adc); /* line */ 
        coverage_0x09f75103(0x6369a0998c69e1e1c28c13a5954764481e6c193315c125c04fc2f1cf460ff0ee); /* assertPre */ 
coverage_0x09f75103(0x2212aa379c52b8b3118af19c2186d1068dac415ec13546792c54cfefd777e4dc); /* statement */ 
require(msg.sender == owner, "VestingContract::updateScheduleBeneficiary: Only owner");coverage_0x09f75103(0x56951799d5baa2dd7cdff20b3bc54bc1b47dba81f8de7c78c5697d647f9d2530); /* assertPost */ 


        // retrieve existing schedule
coverage_0x09f75103(0x30fa867db0dd0fd0b016f8ae42b339652e6e9c12439af7b279a01d9e2697a503); /* line */ 
        coverage_0x09f75103(0x117fb8ccfcd7aa84fb472cffcdefe04c9c3dc196b2be39647482909335be4fbd); /* statement */ 
Schedule memory schedule = vestingSchedule[_currentBeneficiary];
coverage_0x09f75103(0x9214497242fd5faf2151b0086e8735d4db9e2bcb1add4b1bdb82bf1acc38273b); /* line */ 
        coverage_0x09f75103(0xf94ee1c39074d80834c2d23e3bc710e31cd4b238bcfdcac02f980f284d768bd6); /* assertPre */ 
coverage_0x09f75103(0x53fb0c866923f924bff2a53335b1abc02ca5a87e8a163a8657ae7532150ae2f3); /* statement */ 
require(_drawDown(_currentBeneficiary), "VestingContract::_updateScheduleBeneficiary: Unable to drawn down");coverage_0x09f75103(0xf4ae79137f08734a86f3ecb09a29bd85ceb53fd166117d373a46465208b5eda4); /* assertPost */ 


        // the old schedule is now void
coverage_0x09f75103(0xf8aeb520b355b95c1861ca5095b93d9685435c6c1f91a2fcb199e68dade19c06); /* line */ 
        coverage_0x09f75103(0xc8c8b9789fbbbd1397d143248322e0c331869670319ec5e57c8d9c0c89984345); /* statement */ 
voided[_currentBeneficiary] = true;

        // setup new schedule with the amount left after the previous beneficiary's draw down
coverage_0x09f75103(0xaa927aa0a94ad73691c13fd3290fb1cbd6e914dbb4c01ad8ded0c89a76f2bae8); /* line */ 
        coverage_0x09f75103(0x05bbd02c0f4097cfbee10abe65297d9a7c967aa6ace85911697aa9174b0bf189); /* statement */ 
vestingSchedule[_newBeneficiary] = Schedule({
            amount : schedule.amount.sub(totalDrawn[_currentBeneficiary]),
            depositAccount : schedule.depositAccount
            });

coverage_0x09f75103(0xb4b4aaab1251610a0078e3ef66cf1226213bbc80b6bfe0973a7232a57ccbe0d4); /* line */ 
        coverage_0x09f75103(0x5e93ba56c222b0babb5489263fe75c6de363668671db4125c9ea242342799a5c); /* statement */ 
vestingSchedule[_newBeneficiary].depositAccount.switchBeneficiary(_newBeneficiary);

        // ensure the new beneficiary has delegate rights
coverage_0x09f75103(0x0a2e18ea2d38aed05b2ae8dea738912390a31b7689f3fea862b9402fbd2683b0); /* line */ 
        coverage_0x09f75103(0x50ef4e66a80b9ad17902dba10048f3fd24111e837946c5255d9cb57bd67d309a); /* statement */ 
_updateVotingDelegation(_newBeneficiary);
    }

    ///////////////
    // Accessors //
    ///////////////

    // for a given beneficiary
    function tokenBalance() external view returns (uint256) {coverage_0x09f75103(0xc34d35d4c470608bd467073a8142c836fbc20382f80ce816ab6682ba77d7132c); /* function */ 

coverage_0x09f75103(0xd910a8fd8b74e7a9498838349bf775ace470fe391fe90ddcf0133ea811efd440); /* line */ 
        coverage_0x09f75103(0x5271d8411cd77523763b5a10aef548c83b31f3401029d866daa1eba47b8d1465); /* statement */ 
return token.balanceOf(address(vestingSchedule[msg.sender].depositAccount));
    }

    // FIXME move to vestingScheduleForBeneficiary?
    function depositAccountAddress() external view returns (address) {coverage_0x09f75103(0x15493d05326508fda5a3439201a8577ad8891b1a74fddf8cb4c2edfdf02c639f); /* function */ 

coverage_0x09f75103(0xcd080ebc1acfe730ed0527e05b1fceca5562fe2d6ad4ff9483bbba432f50ff3b); /* line */ 
        coverage_0x09f75103(0xd4161f56b4dc554554e77f8bdc3bcd8c6f5a52c11e3e93c9943fd92472a5e4c4); /* statement */ 
Schedule memory schedule = vestingSchedule[msg.sender];
coverage_0x09f75103(0x0e37ce85cf8e7c092191d11f149368457005526e0832470458a60af90470dc45); /* line */ 
        coverage_0x09f75103(0x6abb1fb4b8528fa2f85cddb7088549255b2a6115be0e0bc3288a18150c758fbd); /* statement */ 
return address(schedule.depositAccount);
    }

    function vestingScheduleForBeneficiary(address _beneficiary)
    external view
    returns (uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _drawDownRate, uint256 _remainingBalance) {coverage_0x09f75103(0x7aec5e7868df81d8bffaaa3e9466de0d737bb3d2f4213f4efcf71970044893bb); /* function */ 

coverage_0x09f75103(0xf8abc152f13690a56ee56510fa743a0493ed9b16c59e67244d8028a251d23220); /* line */ 
        coverage_0x09f75103(0x0b070697f472fbe73e1e5ecbc95b6dbdf722e2cbe6a907f82b4543dc4e2dac9f); /* statement */ 
Schedule memory schedule = vestingSchedule[_beneficiary];
coverage_0x09f75103(0x0d82c1650e7b7162802a1377785165aaf54c01a629b5e0fa5abb782e6e98b934); /* line */ 
        coverage_0x09f75103(0xda5fb1089bc84dfba038fc96b80721ff6aa66bcfc6b2f6c0f99bfabeebcbe9aa); /* statement */ 
return (
        schedule.amount,
        totalDrawn[_beneficiary],
        lastDrawnAt[_beneficiary],
        schedule.amount.div(end.sub(start)),
        schedule.amount.sub(totalDrawn[_beneficiary])
        );
    }

    function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount) {coverage_0x09f75103(0x4e34baa139f39251dd9a3f815010c496328185e9ec6b972d5928b25b21a32fe9); /* function */ 

coverage_0x09f75103(0xd9a6fdc48e8918cccadd6234ab4b8bed952baa3fdf483ad4781632133361db42); /* line */ 
        coverage_0x09f75103(0x30eb415252a53687e881d326c5e5876dc16f1d1053d1099ffee19cdce0539b32); /* statement */ 
return _availableDrawDownAmount(_beneficiary);
    }

    function remainingBalance(address _beneficiary) external view returns (uint256) {coverage_0x09f75103(0x982fe04d1af287f530d4c69db8be6cd93a48c320e6da70516a10358c82144b28); /* function */ 

coverage_0x09f75103(0x1bd7871f941d083c0c54c69755cbb1ae7835a7a54218e0e1881a69c05a9de30d); /* line */ 
        coverage_0x09f75103(0xb7edf8d0009364122453476b4c1bdfeb9b7598231e1cdfbf4e522cbd99879777); /* statement */ 
Schedule memory schedule = vestingSchedule[_beneficiary];
coverage_0x09f75103(0xc15a24ae6833c27e75abefbe7b3d9479abead8bd8ac571da3c9449e2e10101d3); /* line */ 
        coverage_0x09f75103(0x1945a8ce7e09ddb6291bad4fe38ff8bc58083fb18d3be55360cab0d8e4a48ca6); /* statement */ 
return schedule.amount.sub(totalDrawn[_beneficiary]);
    }

    //////////////
    // Internal //
    //////////////
    function _drawDown(address _beneficiary) internal returns (bool) {coverage_0x09f75103(0xa2aa8c6f6a84cae3783603069185421cb5708db141eaaf9f518b19e961c14fe8); /* function */ 

coverage_0x09f75103(0xfb2240059657818e577b68bf4fc26e9340f7bb37e95850f222ff2acbddd873f3); /* line */ 
        coverage_0x09f75103(0x01e602dc74b6a2ae99e8a80c372c99f44916dc1cd5bfd2d262fe93d341cd7ef3); /* statement */ 
Schedule memory schedule = vestingSchedule[_beneficiary];
coverage_0x09f75103(0xae8ad7236aa5c85484676a8e9a69226eebf719d72c5c9f4642b82efcd77351e7); /* line */ 
        coverage_0x09f75103(0x8a28207b44ff1edf65e367ee0269bf33dbd9c78475ef97ccab0e65a535b7ad7e); /* assertPre */ 
coverage_0x09f75103(0xc3592b4a4aaf3084be516efce645c3cd0ba3da7bfaa64f24482cb19f2df76dd1); /* statement */ 
require(schedule.amount > 0, "VestingContract::_drawDown: There is no schedule currently in flight");coverage_0x09f75103(0xbc4be1c4581c30fab67760fecd0ad69a1e94bbae189d1c75ab7032a396b92d96); /* assertPost */ 


coverage_0x09f75103(0xd325014dd3b904a3e643813376f144b098d6e43aff24d694c66fa43e1331b9de); /* line */ 
        coverage_0x09f75103(0x60e272a78342fd01736d4239377d3223ac80bb196c63680f5dca8bb5f2127670); /* statement */ 
uint256 amount = _availableDrawDownAmount(_beneficiary);
coverage_0x09f75103(0x131ae8d5c8335adcb120fe40fdd2848af6611f1c7c06601afcfce3d9b82b5e56); /* line */ 
        coverage_0x09f75103(0x328d6bb0d7bd2a0eadefb6f8403505fb3aeb57450369a03a9d8ffa635499b04b); /* assertPre */ 
coverage_0x09f75103(0x0ad77485817820bc56f16b8cebbd5cd2706fd04399ce2545740d7b4fd199eb33); /* statement */ 
require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");coverage_0x09f75103(0x387125e6b6a23698597441ba33201d6cbc03bee3825a67550a4d8e2e3e124ab3); /* assertPost */ 


        // Update last drawn to now
coverage_0x09f75103(0x02e9be9570d454c945baca659c5bc437df3357c976c4aaa91182e58aa4f27145); /* line */ 
        coverage_0x09f75103(0x504ee97290481dc8edecf5fe1dc48e4d8e40e6a7aea348d5a5ef6fda24d15e13); /* statement */ 
lastDrawnAt[_beneficiary] = _getNow();

        // Increase total drawn amount
coverage_0x09f75103(0x47240d79974e1ac9688d55efee2633e70d50abe19553059d4562d595b5caafd5); /* line */ 
        coverage_0x09f75103(0x85dbb0fcd488697e252d046657aa7cd0d3c0732e5ef00b27f185e4405ce93ea8); /* statement */ 
totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);

        // Safety measure - this should never trigger
coverage_0x09f75103(0xd73012dc56b2868cf41d1beb57f0211577079e3633e5c6edfb675039f5935818); /* line */ 
        coverage_0x09f75103(0xa62b94188ccc52dc06794bedd2d7380e0c668956ec238f7a09099dc91ec4dc9d); /* assertPre */ 
coverage_0x09f75103(0xaf049ad81a6520496adaba0bbbff3a55e0c5cc616083d8228d81fcd458120831); /* statement */ 
require(totalDrawn[_beneficiary] <= schedule.amount, "VestingContract::_drawDown: Safety Mechanism - Drawn exceeded Amount Vested");coverage_0x09f75103(0x9ed9515d6ff93ad515df220fdc4a958f00e7171028c185f0d06d022027af6ffd); /* assertPost */ 


        // Issue tokens to beneficiary
coverage_0x09f75103(0x46f99862f06fbc4e9fb63eaeb9c3711f77035a51020d96fef6e95ee9ecb18c06); /* line */ 
        coverage_0x09f75103(0x890639ce7227047e1126ad523f6171ecec34b917179e616fce831170c69e799d); /* assertPre */ 
coverage_0x09f75103(0xdb603fa4db7c2ffbf12ed2badd08fee2e18efea6c3ff2fa4b6ca4d72355861d8); /* statement */ 
require(schedule.depositAccount.transferToBeneficiary(amount), "VestingContract::_drawDown: Unable to transfer tokens");coverage_0x09f75103(0x848bb6b7429f6403338402b49cd112fb07a09acd477d3b22d2fc0b39582c40bd); /* assertPost */ 


coverage_0x09f75103(0xa89029924601442645129889929c1a04d8be7932aca16b03230dd54095841486); /* line */ 
        coverage_0x09f75103(0xc531ae53a4b5dd8a2c1175e64d9a516444b11ddca2d7bcc004b606fb9163f7f7); /* statement */ 
emit DrawDown(_beneficiary, amount, _getNow());

coverage_0x09f75103(0xfdc5d51679755eb0d1bb8fe868fb8dcc08e2cb55f736da04560a31b687cfa555); /* line */ 
        coverage_0x09f75103(0x6494c88e1e741029819305fe5de91da51b7529d099510ab4b0d01071ef4d54a5); /* statement */ 
return true;
    }

    // note only the beneficiary associated with a vesting schedule can claim voting rights
    function _updateVotingDelegation(address _delegatee) internal {coverage_0x09f75103(0xc54396a1ad793f27f101f8d724d4572637d0d5913da18a578e4cdea4444eb587); /* function */ 

coverage_0x09f75103(0xed134c1017038aefe4bf5973b8d6dc15136b5a8bf0f0614721a7f8fb95a415ae); /* line */ 
        coverage_0x09f75103(0x046b06d3c8cf83ec885d3b719158677b748060e2792322e644409eb338f6009f); /* statement */ 
Schedule memory schedule = vestingSchedule[_delegatee];
coverage_0x09f75103(0xb8b53930f985a502e6e55d1a05dddca664bd721c27293276e7b9b566e86ec2de); /* line */ 
        coverage_0x09f75103(0x56aa98166a6a4224daaa464754a872ec810b1275ac7fa3cec42a23125995ad53); /* assertPre */ 
coverage_0x09f75103(0xc2e2576a7fa3d02894f0d96ee671e6d9b7405b164c4f14039c88f3b6d37124a5); /* statement */ 
require(schedule.amount > 0, "VestingContract::_updateVotingDelegation: There is no schedule currently in flight");coverage_0x09f75103(0xc62b760c72a7ed03c91afa0612098b100ee711b96fef9af20bc8abaff7078f79); /* assertPost */ 

coverage_0x09f75103(0xa508e70a8171e65a0ba4007d62a45c267888191a6611aa54b0fb910160f0f338); /* line */ 
        coverage_0x09f75103(0xafe7fea8bf9206b008e80962351b7966e3cc616c453cdf611dfcaf14c0badd52); /* statement */ 
schedule.depositAccount.updateVotingDelegation(_delegatee);
    }

    function _getNow() internal view returns (uint256) {coverage_0x09f75103(0xa2832585e1a6656851a8573171ff126a14e51c0584f1528c65dd57c367f51b26); /* function */ 

coverage_0x09f75103(0xacfdfa4be7591fa039ab26a29e11c70b35d658414269d8ce237d50307f1cd00d); /* line */ 
        coverage_0x09f75103(0x818c880d3ba8d8d4c76306c4386f86697642749ff7139b90c318162795ec4a06); /* statement */ 
return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount) {coverage_0x09f75103(0x9994441aa14bc1544b48d83ef7f70669a5628fb10ffbdb6797aeb31d6296e13e); /* function */ 

coverage_0x09f75103(0xaafbebca8b51e78aa09273730445d142f74be4c8603900a6b31be09150b8b75c); /* line */ 
        coverage_0x09f75103(0x975608eac5a5798a79d6a68fa28d30c8960c8948508532bed2417640ccb43ea0); /* statement */ 
Schedule memory schedule = vestingSchedule[_beneficiary];

        // voided contract should not allow any drawdowns
coverage_0x09f75103(0xcb5282da4ce4d493b6505e31e829f76c525092cba0236fa80702dbaec167be2a); /* line */ 
        coverage_0x09f75103(0x24bef114b655224914c8eb5345e70fd3d1eb251135db29a4dd74acced157baa9); /* statement */ 
if (voided[_beneficiary]) {coverage_0x09f75103(0x00eb6cd62b95c9b02872edfd896046665e7992851b93f0ab43890ba0243f93c9); /* branch */ 

coverage_0x09f75103(0xa824f98c7b7654b52f7584cf5b1d89b50d83856f9e69afa1d17bd1f19605234b); /* line */ 
            coverage_0x09f75103(0x1c445bff77194de8a5a978f564348646d455600ac9cf2ddfdaad77ada5094633); /* statement */ 
return 0;
        }else { coverage_0x09f75103(0x426333ed8ddca847f1ee1580dda868e68605d109a252e73fb97e13a14b9e4c82); /* branch */ 
}

        // cliff
coverage_0x09f75103(0x7936e78458a3a51c6266d0f7bf4008f5c84d73d5a58ba3e58d182e760cdbf03f); /* line */ 
        coverage_0x09f75103(0x5bf4b78e08bc62a30c5665db4df3017cac428208e9f29c57eb7679174cbc592d); /* statement */ 
if (_getNow() < start.add(cliffDuration)) {coverage_0x09f75103(0xc1500dd0d36bd7fe9ac78a24212d3edc95bae54a21b66321c2c59a52bf23f402); /* branch */ 

            // the cliff period has not ended, no tokens to draw down
coverage_0x09f75103(0x7fe7b0d192326e91631bb9cead4eee77bf0c8b882f4f281105b38798c9931a51); /* line */ 
            coverage_0x09f75103(0x21f443df236633c76f642749cf9f23667ad3eb3fb72081f9ded76977c60007eb); /* statement */ 
return 0;
        }else { coverage_0x09f75103(0x4231b5554cd5169b4f88636495e817703d562a9798e61517f77bfc395a21e651); /* branch */ 
}

        // schedule complete
coverage_0x09f75103(0x7b08c71b12337150a48c71f013aeb757e394193588a5c7a1d76664a95de4728a); /* line */ 
        coverage_0x09f75103(0xc8e226e32cee2b522d482cfc8b1fb5d285897c2c975c20c21ce98c764ce66f60); /* statement */ 
if (_getNow() > end) {coverage_0x09f75103(0xdec8c8d6c1020eab9220efbb3e19baace48bbd8e8ac000b1b44e6654f64d62fa); /* branch */ 

coverage_0x09f75103(0x8230fec344b4da48b28bcf7c45169eebd1ac389b66ac28934ddd6cebcdd802b8); /* line */ 
            coverage_0x09f75103(0x8e7a6f2d8f35faf72fb2f4d93ee829a29a8aba70a43d96328fb63d3223d3d60e); /* statement */ 
return schedule.amount.sub(totalDrawn[_beneficiary]);
        }else { coverage_0x09f75103(0xd2a3864b06f44c4a438b7a038f8effee1d0a28324c5ce78423b9b86f9f2250ef); /* branch */ 
}

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
coverage_0x09f75103(0xd744c40675016a1bdbc2219f0cc480342637736c382f159f2b937c3d63f980ce); /* line */ 
        coverage_0x09f75103(0x090f91e9b8952e900daf2f05ed9c54c426ad8e08e6737fdbca432a04e15ca5b0); /* statement */ 
uint256 timeLastDrawn = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];

        // Find out how much time has past since last invocation
coverage_0x09f75103(0x0415fb9aa8443edd6eda0fb1fd55777e17fea547f831928b0d1aa26364512577); /* line */ 
        coverage_0x09f75103(0x5907f41392526d74430d680e73bc05125b43920b25eda5ecf7409a11f00079b1); /* statement */ 
uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawn);

        // Work out how many due tokens - time passed * rate per second
coverage_0x09f75103(0x7ea7e161e14607a59f0281e3d50dde5b785c5321b4c6dfd9c47b0be16f0e2f82); /* line */ 
        coverage_0x09f75103(0x061c4b72a570827d2f9118239d9290540028c040b6aca6be6a575c26f32251a9); /* statement */ 
uint256 drawDownRate = schedule.amount.div(end.sub(start));
coverage_0x09f75103(0x708aa469b4cf1144b47278a27fe126a34ff22cfb08a0599b4728e90515331b5c); /* line */ 
        coverage_0x09f75103(0x9063bbf9a286b565fec76d2576c7991c34a941449b4b9814e199622dbe1ca758); /* statement */ 
uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);

coverage_0x09f75103(0xc282e5e7912f5390955949ea5b2578076ba4a976e5dfb9d356abc9518ccaad8c); /* line */ 
        coverage_0x09f75103(0xd1c5d9c8f3b6fef95fe4e4f4b13222242aeaab7898af16caf4eea3b51d7f9551); /* statement */ 
return amount;
    }
}
