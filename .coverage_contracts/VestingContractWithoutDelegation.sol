pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IERC20.sol";

contract VestingContractWithoutDelegation is ReentrancyGuard {
function coverage_0x2533a6e4(bytes32 c__0x2533a6e4) public pure {}

    using SafeMath for uint256;

    event ScheduleCreated(address indexed _beneficiary);

    event DrawDown(address indexed _beneficiary, uint256 indexed _amount);

    uint256 public start;
    uint256 public end;
    uint256 public cliffDuration;

    address public owner;

    // Vested address to its schedule
    mapping(address => uint256) public vestedAmount;
    mapping(address => uint256) public totalDrawn;
    mapping(address => uint256) public lastDrawnAt;

    IERC20 public token;

    constructor(IERC20 _token, uint256 _start, uint256 _end, uint256 _cliffDuration) public {coverage_0x2533a6e4(0xf09f75e95c43e2bdeb62256602b51f4ebde3ade051028721a8778c3a095f34db); /* function */ 

coverage_0x2533a6e4(0xd632542cb0652f9e360527830c1557c8279f0ae54b6b45ea988e433d9946c773); /* line */ 
        coverage_0x2533a6e4(0x91111d54ba0855016581ff4d6cc577371b773d00e814ef24e4f4d01fbef36573); /* assertPre */ 
coverage_0x2533a6e4(0x607ab96f577abe8972f859e3e375aeb55a75b085f384c92f64378910c5b6726a); /* statement */ 
require(address(_token) != address(0));coverage_0x2533a6e4(0xc26a39f813b144a5110c1e2fabee019b037b3ddb474870761c392e441fca9225); /* assertPost */ 

coverage_0x2533a6e4(0x414dea5d5cf89b71732a2f3829958cca8bc945c5a03b2967f84425cd2c8d28b5); /* line */ 
        coverage_0x2533a6e4(0x944000077b5de894d9d58a4e9bbb1b10511eca85e89be0f4beb47e5ba5caa5dd); /* assertPre */ 
coverage_0x2533a6e4(0xcda6d7269b6618a8276f2760faf0541dd690f519e33136d5f712214dbf4b6ecf); /* statement */ 
require(_end >= start, "VestingContract::constructor: Start must be before end");coverage_0x2533a6e4(0xdbe65855efb6da3ae34f486a207aef349466ba78eb2fe9dc89672c1b50b19b88); /* assertPost */ 


coverage_0x2533a6e4(0xc2d198a1b93e332eabb040fb8421c22a590e2d350b8d2a8af73869af1c8823ad); /* line */ 
        coverage_0x2533a6e4(0x8218361eb3f1addc54e9323666362075ab8680498789aaea93c8bbf1cdcd003e); /* statement */ 
owner = msg.sender;
coverage_0x2533a6e4(0x432dab04289f4f0255299df3675c8de74eb21149ba2db1fc5febc466f3f4e6bd); /* line */ 
        coverage_0x2533a6e4(0x1f135d96655c316d4e77ecfa5da9445f9dfce79d0540ee6e06729b36dbe6942c); /* statement */ 
token = _token;
coverage_0x2533a6e4(0xe04776770b7ea97b614e50dd1ce69fc172a89accb71b9af0facc93ba4f72b221); /* line */ 
        coverage_0x2533a6e4(0x741368c1cda7fc14f83d1f5f6ccab78db53172a72fbbe283605f0202bc31b0ca); /* statement */ 
start = _start;
coverage_0x2533a6e4(0x731cd6fcf5d5692f935403d2d341efebf6bd08da2ad48aa906c72706f55e2287); /* line */ 
        coverage_0x2533a6e4(0x92bc349200bcc2667a8774b6a750bf36bb02b7639d3566a5f51dbb22732f3a67); /* statement */ 
end = _end;
coverage_0x2533a6e4(0xd54b59c390dbf7152ef8497f7bdebb35c4e6a999000b855b07617f6ad67d8991); /* line */ 
        coverage_0x2533a6e4(0x635f9a794ada4e8114d0fb7e67df3ead7309fa187c7cddbd9ccf89cf8c3ae94a); /* statement */ 
cliffDuration = _cliffDuration;
    }

    function createVestingSchedules(address[] calldata _beneficiaries, uint256[] calldata _amounts) external returns (bool) {coverage_0x2533a6e4(0x14a6f2ba10ac9255efde97fea9dda6c7b807db0175689de7c7d98fb6942eccf5); /* function */ 

coverage_0x2533a6e4(0x4e971ddeeb2e2fa417fa7f32cf305264647fbf55c38d1ea03149a4653c80feb5); /* line */ 
        coverage_0x2533a6e4(0x64719c48d5d7d37feb2019c29b86cb51b69e8b1d7292fda5c3377d8ccce80a34); /* assertPre */ 
coverage_0x2533a6e4(0x664447967e8b3edf8be2bd40aadaa66da1a0417f25ab1ad2937b75997711d4e4); /* statement */ 
require(_beneficiaries.length > 0, "VestingContract::createVestingSchedules: Empty Data");coverage_0x2533a6e4(0x1cf2a98afe16709995bd4facc02faebbb8b57fc01942cb1cfa5804f0f7513946); /* assertPost */ 

coverage_0x2533a6e4(0xbe6b72841c8cbfed000ccdc019e27e1880836ad7ed00590230fa0316691786db); /* line */ 
        coverage_0x2533a6e4(0xe7417d28bd0b9f561f374f5c80cffb85f384aa418352dc44ba6a8c144cb6ea69); /* assertPre */ 
coverage_0x2533a6e4(0x445f6e6dd6e76f846b03866955d819231660380522d0129e2362992286befe01); /* statement */ 
require(_beneficiaries.length == _amounts.length, "VestingContract::createVestingSchedules: Array lengths do not match");coverage_0x2533a6e4(0x8feb935e143afe753cf29002d41db62b6614239f878fde7c5b3c28adeadce97c); /* assertPost */ 


coverage_0x2533a6e4(0x4347820776d55e3e06702c725a43c61fa221167dabbf263812f69f35ccf9a359); /* line */ 
        coverage_0x2533a6e4(0x91695a35f774f25013a13f0e4c12b0dc2810d6a6718ac64c1a7b2a3e3743af90); /* statement */ 
bool result = true;

coverage_0x2533a6e4(0xdb4dd77dc879df6d60acda07612515985941779db3b1672cb541176b9d053c22); /* line */ 
        coverage_0x2533a6e4(0x06ba0348097bc7b624edfb361ccfd2de21b26037082d79bea0f1bab6ed9dfbb9); /* statement */ 
for(uint i = 0; i < _beneficiaries.length; i++) {
coverage_0x2533a6e4(0xa247369b625cbc31b91cc0026ff73bfef7fdef32b3d5d95b2b18a6481437ca71); /* line */ 
            coverage_0x2533a6e4(0x785a1bf8dae4476219d8b03b863f23664b9716f423c529b9f88de9e9ffc1a11e); /* statement */ 
address beneficiary = _beneficiaries[i];
coverage_0x2533a6e4(0xa6e1614b40c5f91c0799fed802ca67fea399c33c349acacbe3ced9df40d69030); /* line */ 
            coverage_0x2533a6e4(0x635793613320a63d2fecc43c9e39de2b8db4d849b62bf80722135159fb9f8c36); /* statement */ 
uint256 amount = _amounts[i];
coverage_0x2533a6e4(0x2fdc5ea06008fb92156ea1e06a13899a62340b8f15c4838629b42f91d23a8c60); /* line */ 
            coverage_0x2533a6e4(0xfdf1c36e22cb9ee440ec241f7681a9f1a7806db94102e74658e547f00b29d441); /* statement */ 
_createVestingSchedule(beneficiary, amount);
        }

coverage_0x2533a6e4(0x10f109ccb3f7383842add8b39abef178d22d89c6b71ab814fe2877e49bbee6a0); /* line */ 
        coverage_0x2533a6e4(0xfd0b6132cc2221ff8fc04b654171f241c817607b587cd5e808a1a6b2e805d9e9); /* statement */ 
return result;
    }

    function createVestingSchedule(address _beneficiary, uint256 _amount) external returns (bool) {coverage_0x2533a6e4(0x38ec81e45e187410f245e29242da61fe2e6d675028ca6db7b4db0a74757ad0dd); /* function */ 

coverage_0x2533a6e4(0xebe0596e13b11911125bc7f26fb6f488285bd02637dacc21722aaf2615d49142); /* line */ 
        coverage_0x2533a6e4(0x688336865ab723b53b62a239d862aa59bf639f9228dc25ae27480c4ea0f5b37d); /* statement */ 
return _createVestingSchedule(_beneficiary, _amount);
    }

    function drawDown() nonReentrant external returns (bool) {coverage_0x2533a6e4(0x54ccfcfeea2f139fb0e4c72f2ab029d101881e8c9dbb1964bc75d04898464170); /* function */ 

coverage_0x2533a6e4(0x3196d9293a35c48f358843603a32e3687efcec68e6d78bbb6f99f92e31579927); /* line */ 
        coverage_0x2533a6e4(0xae3d6e669c674ea5648e5ec8c77e83c2bb0e645ff97e3949e5e7809d030637cc); /* statement */ 
return _drawDown(msg.sender);
    }

    ///////////////
    // Accessors //
    ///////////////

    function tokenBalance() external view returns (uint256) {coverage_0x2533a6e4(0x7aee599c96dddca7d2c989b891884ed60ecaa0527b47f7a527a6a0b32017acbf); /* function */ 

coverage_0x2533a6e4(0x4e181fae96f1aa00a8421c848539902d6fb5f0945ebf1c0092c867132c26b47b); /* line */ 
        coverage_0x2533a6e4(0x18faec2ad3fb4ac442d0ae96e93d014698b676e120d7ab5909636513d804a29f); /* statement */ 
return token.balanceOf(address(this));
    }

    function vestingScheduleForBeneficiary(address _beneficiary)
    external view
    returns (uint256 _amount, uint256 _totalDrawn, uint256 _lastDrawnAt, uint256 _remainingBalance) {coverage_0x2533a6e4(0xbc7fb34d30e5f799b1ecd9361d471a1f22b814d6edc73960b502fc3daad81930); /* function */ 

coverage_0x2533a6e4(0x7c4b2b68edb35fcd1ac835211fddcf7d3a21599087fa6da83f3abe11a707b3b0); /* line */ 
        coverage_0x2533a6e4(0xef07b66f519002960d67f20053a5fb5b75955a8892e09e230bedb32af228158f); /* statement */ 
return (
        vestedAmount[_beneficiary],
        totalDrawn[_beneficiary],
        lastDrawnAt[_beneficiary],
        vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary])
        );
    }

    function availableDrawDownAmount(address _beneficiary) external view returns (uint256 _amount) {coverage_0x2533a6e4(0xd4a042fa1278b8ca9b908fed9e1ddc966ce5311f69c2e0993eedcb223f3bc593); /* function */ 

coverage_0x2533a6e4(0x22aea2306e87d907d9c7d4817a0380817629760cd8a978aa121d73a46339b92b); /* line */ 
        coverage_0x2533a6e4(0xc34a9a0f7c22b8e0aad51cc7583215f904d4852a2ba2efb85ed3729c6cc69912); /* statement */ 
return _availableDrawDownAmount(_beneficiary);
    }

    function remainingBalance(address _beneficiary) external view returns (uint256) {coverage_0x2533a6e4(0x10f2d6c06744c963210668a8d92511b279077fc6f3ec0885ae58690fd8aff7c1); /* function */ 

coverage_0x2533a6e4(0x2a7e0709731854c57884a20ea11ee797d519ba2f5887358e77d532c622dd80d2); /* line */ 
        coverage_0x2533a6e4(0xc7536039c1760666f2750665638460af0541f348f51d8c56f1c476ea27be1e68); /* statement */ 
return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
    }

    //////////////
    // Internal //
    //////////////
    function _createVestingSchedule(address _beneficiary, uint256 _amount) internal returns (bool) {coverage_0x2533a6e4(0x923f5cce0afccda54f158b77c7fecbc40920ebc5f1e464a9b9846c62324146d3); /* function */ 

coverage_0x2533a6e4(0x324479b8dbd2c6f02d499924447db0fabaa2cb758a0ec4ff95fb0cc67a8adbdf); /* line */ 
        coverage_0x2533a6e4(0x14b37ae2c0283ace59b09dc7d839e7f845c1943fb214b239835e63ce50736a60); /* assertPre */ 
coverage_0x2533a6e4(0xfc41172cb9eb10caad647dd7e7d7f1445b324a9b0ce3ebae821a22c578d35870); /* statement */ 
require(_beneficiary != address(0), "VestingContract::createVestingSchedule: Beneficiary cannot be empty");coverage_0x2533a6e4(0xf6111813bc7c3e584577f9eab4a9fa51509ce0ff5d073a1b28c1fe6e5ec28d82); /* assertPost */ 

coverage_0x2533a6e4(0x57d704cb3c622cf79e4b64f82e26b87935c843c1473a8de7a8006591bd709ccc); /* line */ 
        coverage_0x2533a6e4(0x7680d4dd01b984dfcde2bfeb374b6ffe519d21063883fb42c9d4f497d6f99b9d); /* assertPre */ 
coverage_0x2533a6e4(0x9c8d4ca3f080cfd5ef48a87fd822249986e0d6f8a965f55d330e853869833140); /* statement */ 
require(_amount > 0, "VestingContract::createVestingSchedule: Amount cannot be empty");coverage_0x2533a6e4(0xa16410181173e2d104db449b64bca9dede61a0e125b02cb59c714054485e53d5); /* assertPost */ 


        // Ensure one per address
coverage_0x2533a6e4(0x6e56bcda82f9a50d3839f795e8cb3ae08a09ef1a681d786106ab2efc6e4e443d); /* line */ 
        coverage_0x2533a6e4(0x66b0e8f34189c99704902fa3e7546d2195e926c0b952d0c5dafda1fbbb55d096); /* assertPre */ 
coverage_0x2533a6e4(0xfd8c70fd60e4d3e29b397f000ea434672d0209ffae46cfe686c4f85f2d8cb193); /* statement */ 
require(vestedAmount[_beneficiary] == 0, "VestingContract::createVestingSchedule: Schedule already in flight");coverage_0x2533a6e4(0x0a369e9b3864eb3e635364d5bfdd81817011a60b2b6c5d0f0e43768a7e5cfdcb); /* assertPost */ 


coverage_0x2533a6e4(0xfecf9a5d1167c0fbf6801c84f96536c5fd5d578413a5f8ad60d5433c0907f5a5); /* line */ 
        coverage_0x2533a6e4(0x8257f4e42e4408f3239f6e722953b84f697972f86415e44e55fcf9c800a0667a); /* statement */ 
vestedAmount[_beneficiary] = _amount;

        // Vest the tokens into the deposit account and delegate to the beneficiary
coverage_0x2533a6e4(0x64a7f6296930557c28e08bc15819f5cc56df06010902e021b3923dd3a6c6237b); /* line */ 
        coverage_0x2533a6e4(0xd7f0348ceab9e569551dbeaf48cb7983597ebffa6a2b6536eae660f01172f4d3); /* assertPre */ 
coverage_0x2533a6e4(0x5e1667ee15386f9153d08d78fb9aa8312bb67acdaa2256612334d9a477227423); /* statement */ 
require(token.transferFrom(msg.sender, address(this), _amount), "VestingContract::createVestingSchedule: Unable to escrow tokens");coverage_0x2533a6e4(0x6b5309e4d748e2f23e71edea825bc1db5ad04f8bf2de8db838b92cc32bfff6a5); /* assertPost */ 


coverage_0x2533a6e4(0xbcacc9586d79344a53c809d5bdb241740a6b3e9ab75ea0c537bc842a68d91f12); /* line */ 
        coverage_0x2533a6e4(0xb4a326f395f14d6f4440db5a78670ac6b7a4a2f1822480c24474e03f389b761f); /* statement */ 
emit ScheduleCreated(_beneficiary);

coverage_0x2533a6e4(0x2add7249e71413b94ca655edefec4002fd835178dfa389f4f0363806bc4dcf45); /* line */ 
        coverage_0x2533a6e4(0xb7494fa19bb34f4b8e4779091c65673c1476e00b6601f067fdb79bcd3e6db9d3); /* statement */ 
return true;
    }

    function _drawDown(address _beneficiary) internal returns (bool) {coverage_0x2533a6e4(0x78ee0c2f75dc42271ef055438b188ecf83798c1be84ce2767f040988767f600f); /* function */ 

coverage_0x2533a6e4(0x059aaaf7f4b4c5c713e6a66c7c5881470c5eb1e48a62501748733e281d08ad83); /* line */ 
        coverage_0x2533a6e4(0x4b8be263d835fc803af40955a19f7d897b02a8f8008cb9d8ea5600b2637d7b97); /* assertPre */ 
coverage_0x2533a6e4(0x43a1b3aa1a6e65b403bf0d244ba12eb65fe0dadf5ad0e9d57cf574d411861884); /* statement */ 
require(vestedAmount[_beneficiary] > 0, "VestingContract::_drawDown: There is no schedule currently in flight");coverage_0x2533a6e4(0x4f44a44db93d480faa683db4ecfa0bcaa1ef4815e2e250da1e8a7e1b972b7224); /* assertPost */ 


coverage_0x2533a6e4(0x196ae2403019d813ae82ce6618532bf1c37b62a92f5261bc69cca547fde1e73f); /* line */ 
        coverage_0x2533a6e4(0xf2d8d40397cb35c39458a0a8c6c8993cc27077f19f07e2c14e3464fa22f1f7bb); /* statement */ 
uint256 amount = _availableDrawDownAmount(_beneficiary);
coverage_0x2533a6e4(0x60111a25cc57ae478a3afa37bb482288752e9e99175464bfd074dc76d89cdfd6); /* line */ 
        coverage_0x2533a6e4(0x438c187957902a7559799c4e9c70b7e3e157630afb7de5daf066f147a1b78549); /* assertPre */ 
coverage_0x2533a6e4(0xe8b8f54bbe555f57621f6052d7ba19cde14240abe07184468e018e1340e60683); /* statement */ 
require(amount > 0, "VestingContract::_drawDown: No allowance left to withdraw");coverage_0x2533a6e4(0x2d38dfadce15959b0cfba08edb767f758a87f8e13784af8c8fb78321c96e7c71); /* assertPost */ 


        // Update last drawn to now
coverage_0x2533a6e4(0x3347d174ed8792a641a9a577bfdd60399cc4839a163ad8cbf442a015a6047adf); /* line */ 
        coverage_0x2533a6e4(0xe5259db4a8b43641298a5615f5bfab478b52bdbb8fa9c95e3623cf3c37fc7701); /* statement */ 
lastDrawnAt[_beneficiary] = _getNow();

        // Increase total drawn amount
coverage_0x2533a6e4(0x745502e271943f1593c40a3ce7576294f5ed7ba3944f7f5a3e7b2411b7f1e275); /* line */ 
        coverage_0x2533a6e4(0xc39fd3f4263b1ce8cdb83fb381662cff9d93c5586fc7fdd13a8eeda410e3bffc); /* statement */ 
totalDrawn[_beneficiary] = totalDrawn[_beneficiary].add(amount);

        // Safety measure - this should never trigger
coverage_0x2533a6e4(0xa3674312f8fd02a9d810f30cfabaa17491770c9d5bbe9362bbe3a386db8dc40a); /* line */ 
        coverage_0x2533a6e4(0xdc9d3b2461c1f2fc764da1cb6160bb336a76a9ef1e90d10e2180252f1928fe1c); /* assertPre */ 
coverage_0x2533a6e4(0x235706c0218540e205b731efe762b168cf0f5b81e32042b682dca6ee9b8645e9); /* statement */ 
require(totalDrawn[_beneficiary] <= vestedAmount[_beneficiary], "VestingContract::_drawDown: Safety Mechanism - Drawn exceeded Amount Vested");coverage_0x2533a6e4(0x564ef4b5d4ca490a0abfabd28dde07cdad89b2be165535625b7b5ca2bd3bda0a); /* assertPost */ 


        // Issue tokens to beneficiary
coverage_0x2533a6e4(0x825e847c6d705a20f91dfe16ef65e1c439af9ebff4e4a6b7c8950432cba82ff4); /* line */ 
        coverage_0x2533a6e4(0xf57569dd193eee0056e623e4e95ef811220436eca70e80a59618ed63b9d2a790); /* assertPre */ 
coverage_0x2533a6e4(0xa8e8b5a0354f1b32496ddb960cec27f44150ca0b6493589e483a68054a0b97dc); /* statement */ 
require(token.transfer(_beneficiary, amount), "VestingContract::_drawDown: Unable to transfer tokens");coverage_0x2533a6e4(0xa08aaae46b25116757447acefe3e50f14970b9dd643e61c81ed2e75c81c919d5); /* assertPost */ 


coverage_0x2533a6e4(0xf65752e3c4bd75bc94403e3dfadc579017aced9b05887c97323a0f3156a830f1); /* line */ 
        coverage_0x2533a6e4(0x82f5be769a67ae3e1057c00d07995ffacf08dc8d7ccc0d5080e597d10fd4d3a3); /* statement */ 
emit DrawDown(_beneficiary, amount);

coverage_0x2533a6e4(0x0e9304048a3faeb5cfa2beeb401a46a723b1572e7866e40b3ffadc88007724ce); /* line */ 
        coverage_0x2533a6e4(0x04d994d6c85c845533ca0759ba253f17be7e6ccb07b814cfccb9bf21559a441d); /* statement */ 
return true;
    }

    function _getNow() internal view returns (uint256) {coverage_0x2533a6e4(0x8136810c9704b9cea97213cd5af9cf560a4587716e9b5255f246fc8eb624bf25); /* function */ 

coverage_0x2533a6e4(0xd8f8b82d2091ba2ebbc780da73b9b44f3365bda92e416a929a4096dd38be05ad); /* line */ 
        coverage_0x2533a6e4(0x638915d638551f3993c617544466d727fcd37fcf350d9d7cfaa802c826d398fd); /* statement */ 
return block.timestamp;
    }

    function _availableDrawDownAmount(address _beneficiary) internal view returns (uint256 _amount) {coverage_0x2533a6e4(0x8886dcafe101207aabfb1159ddcdc91dc4d2ad05132af415d91a7c4d9bfb346d); /* function */ 

        //////////////////////////
        // Schedule not started //
        //////////////////////////

coverage_0x2533a6e4(0x12c6d6b9ead9f05ae0de2d12f81cfbf95623f82052b2e25817a815b846df897d); /* line */ 
        coverage_0x2533a6e4(0x97ad2a19c68e9e734adad44847a18684ac2354b84203afa43bd160ebcf37a70d); /* statement */ 
if (_getNow() <= start) {coverage_0x2533a6e4(0xdb731af9f256e0a93ae459288777e451ec52cfdd693d75925fc4d6fbbcd7ef60); /* branch */ 

coverage_0x2533a6e4(0x37b3cfdb8af76792dc000cc92208f2155a40a38908b599e343bb2abea37f3e72); /* line */ 
            coverage_0x2533a6e4(0x7a270b376e2c0398709a4ad9f4ff079ab06aa87053f463b4c9cd0b06b77932f7); /* statement */ 
return 0;
        }else { coverage_0x2533a6e4(0xf6a4878c8d0417ba18bc916bc68d12faf1b15f1e87a1f023ac4e040410361e82); /* branch */ 
}

        ///////////////////////
        // Cliff Period      //
        ///////////////////////

coverage_0x2533a6e4(0x22bf140b4605a4f2be77fe01ea35444307fa4ccf74bb922145ae8276a01f7f10); /* line */ 
        coverage_0x2533a6e4(0xc38bf701b399a6664a49956cd6c40f16c2fab865e467cef000abd07746b2ab90); /* statement */ 
if (_getNow() < start.add(cliffDuration)) {coverage_0x2533a6e4(0xf7fa0b58fd0fff9bb748c4a7b2e750ab5f6c67a98575843ac5598045b71e85a3); /* branch */ 

            // the cliff period has not ended, no tokens to draw down
coverage_0x2533a6e4(0xf019748e93fcc435760208bc84e9a72e9b64b8a69a21a1d160afbd0b55f64ae4); /* line */ 
            coverage_0x2533a6e4(0xeff2457803f40a09c9da91162ebfd416ee242523c67ceb906b13cd56bab2044c); /* statement */ 
return 0;
        }else { coverage_0x2533a6e4(0xe8181b987dbcd6596c7d362779115b55161b1fc547a9c133e6243f09dffa2edb); /* branch */ 
}

        ///////////////////////
        // Schedule complete //
        ///////////////////////

coverage_0x2533a6e4(0x116550036e76a196b337e9e4de68d0eed87c51de47a80b3b2fcfa966abd8c29b); /* line */ 
        coverage_0x2533a6e4(0xada4422f9e2f0db3ef880c0d37f1f69993a26cf466a75d58bebb319db7f109c4); /* statement */ 
if (_getNow() > end) {coverage_0x2533a6e4(0xe498c763ccf03d45022ce69a9a0d3c1ef761fc4db31cfc268f8b62fd176aaece); /* branch */ 

coverage_0x2533a6e4(0x9a04d818fe275fbd0765b0f1eea19661f384d5413c969aeb42713e6673ca8d1e); /* line */ 
            coverage_0x2533a6e4(0x17c095b4cb767a00f8007498c2b5c9c6ce5cfa81c2ff619999d21fc499c2c1c5); /* statement */ 
return vestedAmount[_beneficiary].sub(totalDrawn[_beneficiary]);
        }else { coverage_0x2533a6e4(0x8527dcde78ab94268f1c5935619fb4a3959079ce62a07f55bb6216222e73bc7f); /* branch */ 
}

        ////////////////////////
        // Schedule is active //
        ////////////////////////

        // Work out when the last invocation was
coverage_0x2533a6e4(0x192cdf96b4355d691d3b7d356be46c05daedb2c676d801fc19ed798ecc62ca45); /* line */ 
        coverage_0x2533a6e4(0x631864bcb356e62b6a8a6f476ae79db1d74501fa6787b4d98c7d8e69f561ec60); /* statement */ 
uint256 timeLastDrawn = lastDrawnAt[_beneficiary] == 0 ? start : lastDrawnAt[_beneficiary];

        // Find out how much time has past since last invocation
coverage_0x2533a6e4(0x4df2b7f17202586fffca122e87f507f8c3fec2d4b81dffa8b91ff747d089288e); /* line */ 
        coverage_0x2533a6e4(0xa69e2d211da6ad5c57e5cc262f70d49a2e3b75e3f8f37e5d218f346b41f10fa7); /* statement */ 
uint256 timePassedSinceLastInvocation = _getNow().sub(timeLastDrawn);

        // Work out how many due tokens - time passed * rate per second
coverage_0x2533a6e4(0x04189955028e1deb943d306c47fb8ebc1b544691b554c3d6f35d26b432791363); /* line */ 
        coverage_0x2533a6e4(0xecbae0e10569bd12cb2475354e777297d9e7ec74c651f31b60b8f80c81ee41a0); /* statement */ 
uint256 drawDownRate = vestedAmount[_beneficiary].div(end.sub(start));
coverage_0x2533a6e4(0x6f367dc9241a35d5f3d9841f436bc8883d633b51894a2bfb71cdced1ca148e75); /* line */ 
        coverage_0x2533a6e4(0x76f99236255403e97b4fb4319a84266faf9a4eb1128d0d28370cd0cbd3bfcb1c); /* statement */ 
uint256 amount = timePassedSinceLastInvocation.mul(drawDownRate);

coverage_0x2533a6e4(0xe7872b8ca0244a40af287290981b8e36ea05dedb0b85d239b2f504d75acf1229); /* line */ 
        coverage_0x2533a6e4(0xd4e573c0702db04ed23b986cd6146d8518e23ce7b7956f832437f2b21ac645a7); /* statement */ 
return amount;
    }
}
