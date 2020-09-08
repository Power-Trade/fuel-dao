pragma solidity ^0.5.16;

// Copyright 2020 Compound Labs, Inc.
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import "./SafeMath.sol";

contract Timelock {
function coverage_0x981af3b4(bytes32 c__0x981af3b4) public pure {}

    using SafeMath for uint;

    event NewAdmin(address indexed newAdmin);
    event NewPendingAdmin(address indexed newPendingAdmin);
    event NewDelay(uint indexed newDelay);
    event NewGracePeriod(uint indexed newGracePeriod);
    event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
    event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
    event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);

    address public admin;
    address public pendingAdmin;
    uint public delay;
    uint public gracePeriod;

    mapping (bytes32 => bool) public queuedTransactions;


    constructor(address admin_, uint delay_, uint gracePeriod_) public {coverage_0x981af3b4(0xabcf83a2729262a07c126ee3b1ee1cda4609847e54b6be90b4fe1522c9216112); /* function */ 

coverage_0x981af3b4(0x13b4100e14261d815a2e4529d7a1e84e1492f975a9299f854464778f59ed444e); /* line */ 
        coverage_0x981af3b4(0x946189a53ca8ed5c938822ff4ef7fb4d3204a5b0c8abf724fada0885d1f31bd9); /* assertPre */ 
coverage_0x981af3b4(0x4c00c7dcbac2207e6d76e1b382bac362e3b89fa8da420fcb8ef4e3b2794fa039); /* statement */ 
require(delay_ > 0, "Timelock::constructor: Delay must be larger than 0.");coverage_0x981af3b4(0xb585f18e801bada92595e7fd9525d7dade955662bc49fb584251ffbee9995010); /* assertPost */ 

coverage_0x981af3b4(0x819a656b98e8ba283238f208d91659653134ed95a66a485fd109f9df306948ba); /* line */ 
        coverage_0x981af3b4(0xd0b2d8e467cda65b8b1ee99c6b97044bf6ed57c5e32c6cae5fca85d467288b9c); /* assertPre */ 
coverage_0x981af3b4(0x17ad18124f2ce53e1e85008e5d88e3bd604b528304846d0e1a47e9be72c6c012); /* statement */ 
require(gracePeriod_ > 0, "Timelock::constructor: Delay must be larger than 0.");coverage_0x981af3b4(0x14ff5fc1f80a7affd3067da740523e7ab49950be61c891c5b81dac506e8d8f5f); /* assertPost */ 


coverage_0x981af3b4(0xdc7213f2fc5b2373224c2c685f06bb3ce2392cca2558f7d7e21212175c72b55a); /* line */ 
        coverage_0x981af3b4(0x1982cfd0590f1cd2cfa17efd85d2cd2e5f6c1114834b67df5f3e5c9575899cb8); /* statement */ 
admin = admin_;
coverage_0x981af3b4(0x3356917e13f8a3c13bdf976aa8cecce1ef96ea4363ea21357cc074d41f4f986f); /* line */ 
        coverage_0x981af3b4(0xd9f8f47ecc398ecae07b9f224ab528c1bb0ca819af32ae09832b7744e07979a8); /* statement */ 
delay = delay_;
coverage_0x981af3b4(0xe3fbd3ce2a1239bcb466638eae2b250f36baa04f8bc0433db46408ac2095c317); /* line */ 
        coverage_0x981af3b4(0x80f4eabf0588de926cc7c15680103d1d31c448692aadbae30c5378cf75f6318b); /* statement */ 
gracePeriod = gracePeriod_;
    }

    function() external payable {coverage_0x981af3b4(0xe5f80840737e5d506e04b10b74fd254cd3a1f18e53215846479e410d4fd158bb); /* function */ 
 }

    function setDelay(uint delay_) public {coverage_0x981af3b4(0x6670b94aca5b1434f417f00bdf8c2f8baf8056de6e9c7c97eac4ebb7a69334a5); /* function */ 

coverage_0x981af3b4(0x3c3b18e53e4a15fe0436d502670b371132fd23a2c1402b65cd619c17007991c5); /* line */ 
        coverage_0x981af3b4(0x21bff131771e6fd447a94fe1f98646b5b77ed7d337d42b5de00ac560a8e53c09); /* assertPre */ 
coverage_0x981af3b4(0x4e19ce0d75b8ddbaabdb97cc1a1db8206685610cfc98e705c22662572ab516b5); /* statement */ 
require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");coverage_0x981af3b4(0x6979e52c8a790d8dedafb0660779f34a4bea5a7cf6f558c13c5a6e88bc6e0362); /* assertPost */ 

coverage_0x981af3b4(0xfd686da1426171077adbec9c9fc3b66d405bfb3469804d7f1c57a40337eb25d9); /* line */ 
        coverage_0x981af3b4(0x4dae30797cd6f1531b02f195bf4f9f248ad6da5c10f112212e7f72546a92c6d3); /* assertPre */ 
coverage_0x981af3b4(0xb0fd5afaf9d52c9534094c1ec87c0717eb9521da9a1668f0a7a224dbea221baf); /* statement */ 
require(delay_ > 0, "Timelock::setDelay: Delay must be larger than 0.");coverage_0x981af3b4(0xe0eb61e473661da07b923ff7ba0e59c3c575f498eb5d3b542200c3d38d676ddd); /* assertPost */ 

coverage_0x981af3b4(0x882877464bcee67ae72d311e66056e83c589f228470344ebd0ae5efd4b8ae19e); /* line */ 
        coverage_0x981af3b4(0xf2e4d9fa5915e56099f2d56c3f0a844ecd2ca6894ed0e028f4f5e5b5e7658473); /* statement */ 
delay = delay_;

coverage_0x981af3b4(0xbdb39ba3f1a4b6b2a20dbc35cbffb71cb2a43db09cbd5929237027cd3aa26fa9); /* line */ 
        coverage_0x981af3b4(0x156a548f38fd8938327f68bf22cf5cb79d750a86542194bd7014c63bb76369f1); /* statement */ 
emit NewDelay(delay);
    }

    function setGracePeriod(uint gracePeriod_) public {coverage_0x981af3b4(0x8b7c170f07478697daaf764b0e7b365fd574b5f376cef52ef299d401cea02e7b); /* function */ 

coverage_0x981af3b4(0xf9dd66552f082a20f950b7d99f8298a2ddc374a16de3baf8ddfeb30cf719177a); /* line */ 
        coverage_0x981af3b4(0x558724c161522f35fe3a640b033674618902fd0ce1c41c2218b2a64f867c84b5); /* assertPre */ 
coverage_0x981af3b4(0x403a766b5990e1b080fcb75a9a4e9fb72448c680ebef904bdf69e1f41d676dde); /* statement */ 
require(msg.sender == address(this), "Timelock::setGracePeriod: Call must come from Timelock.");coverage_0x981af3b4(0x0627fe03cca7b4083af2b2a0760446525df719dd73afef713a0d241d603afd1f); /* assertPost */ 

coverage_0x981af3b4(0x2bd1b7e6640b71238098454672d5b9f2328ef5298e3e5e2c53db4f89916091d1); /* line */ 
        coverage_0x981af3b4(0x944d80437807a9bc145ac6d7706188ea02ef086b8b9c03e56f8d11febdcd6567); /* assertPre */ 
coverage_0x981af3b4(0xfc4d2703b32a389b76b2ae77c02ef49866f3cdb7f419f7b2924c7704ed250772); /* statement */ 
require(gracePeriod_ > 0, "Timelock::setGracePeriod: Grace period must be larger than 0.");coverage_0x981af3b4(0x90c1e94ca967a1a04f15a1b9f5fefb62ddc9d1148de0ba9066d503b089434d4b); /* assertPost */ 

coverage_0x981af3b4(0x4ced2a32c736ad32a09a03915cfe4021d2528b70033164684c93dc49d5a27fe3); /* line */ 
        coverage_0x981af3b4(0xe9205594d3afa593672c51b8940c7867ec8dbdcdb830f5a55ec27a5936960ec2); /* statement */ 
gracePeriod = gracePeriod_;

coverage_0x981af3b4(0xd1b3b26ada76cb8fd7febad275928fb5b500805b2dba482c75429d330a42c9c4); /* line */ 
        coverage_0x981af3b4(0x7db65c85bb1f535939594d0cd4dd190019e66e1ad225b0f6015b7292b0d56336); /* statement */ 
emit NewGracePeriod(gracePeriod);
    }

    function acceptAdmin() public {coverage_0x981af3b4(0xdbc49d2b2686d26351bef1b419a602ea3bbc4b1b13416969979044aee77ffb8d); /* function */ 

coverage_0x981af3b4(0xf299f6b3567e17e5f1ebc6848ca3914accaeb9fb226584b59bc9af0e6537d8bd); /* line */ 
        coverage_0x981af3b4(0x1bf41925eb3790c00a149714c57f90110e3a9d2a7e7f29b0d9830df187bcd461); /* assertPre */ 
coverage_0x981af3b4(0xb569d59e3dd9833d0b04abfdb8590c064bd496e6b8e53f7b23cc5f8d8a516ab0); /* statement */ 
require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");coverage_0x981af3b4(0x042c268ff7047826b3e4bb52a5e0d99f8593f15c049094f10bb185af2a42728b); /* assertPost */ 

coverage_0x981af3b4(0x929d9b9b5ffe660a9fb32306ccaf31718b6688b152f2151ce77d161417e517a3); /* line */ 
        coverage_0x981af3b4(0x9e93f928b6a29259aa9de405d927c002ad2966a92f0213d68539d73646c303dc); /* statement */ 
admin = msg.sender;
coverage_0x981af3b4(0xf219e7311ddc1ee340930c535ec5fe8987af572f401e8fd7eacf9298823f093b); /* line */ 
        coverage_0x981af3b4(0xaf013c78e6da624e6ac938c1236a63227f577cab0c28bcdb4bf29faed68a3270); /* statement */ 
pendingAdmin = address(0);

coverage_0x981af3b4(0xe7b52be3fb043b7929b3bf3bbeb7a5107db67e52988dcecbfeceac85a875f446); /* line */ 
        coverage_0x981af3b4(0xa9c9ec5682fb5b220667bfef6f0f4bf6aa83eae3b038af8c6b64dd0d901f8dbc); /* statement */ 
emit NewAdmin(admin);
    }

    function setPendingAdmin(address pendingAdmin_) public {coverage_0x981af3b4(0x7ed7a3fec356e3f4f1dfb1528328bdb4e69c608ea00a0b99679c51b5478be7ba); /* function */ 

coverage_0x981af3b4(0x8a1c21a2715907b7f816a8bb31b3eba123263bf8f7a50ad2f90e61fa11689d1c); /* line */ 
        coverage_0x981af3b4(0xad910238bbdc26b9ee186a163156699b6b8bc7351b8f58d6167ff5ab7a532817); /* assertPre */ 
coverage_0x981af3b4(0x62ca79683118982a6b1d617d499f484a0acb41d94c6c25631164779585fcf2a5); /* statement */ 
require(msg.sender == address(this) || msg.sender == admin, "Timelock::setPendingAdmin: Call must come from Timelock or admin.");coverage_0x981af3b4(0xeb081857f9aa0213e66c3aa33217a1891016820de53d562ed9cea70cc6971738); /* assertPost */ 

coverage_0x981af3b4(0xcca7fa876b25520738c28b23c45b8391fc0ec8bf8a3bc03d3b03efe79e2e843d); /* line */ 
        coverage_0x981af3b4(0x7fd08305c6c06c1f9946cc15dfb3cc1a22fc5675087182c7601ccaf198a09454); /* statement */ 
pendingAdmin = pendingAdmin_;

coverage_0x981af3b4(0xfaca9f9f838e5e057aae47d72c9c78448062ac9c521285f796ac119ff19fb6f4); /* line */ 
        coverage_0x981af3b4(0x2b78d110d3ca1a11f3a036ee05cef39decdde352cc2f70353c815d1fb299dd1a); /* statement */ 
emit NewPendingAdmin(pendingAdmin);
    }

    function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {coverage_0x981af3b4(0x8a8cf074f5e34567799f3a291082e9640124dfd16aaaed0cc6988a78b174bb55); /* function */ 

coverage_0x981af3b4(0x35e506e87be6d7b3e37901f0b9357e8f108bb088fa6d2c7e6f1a4998a8968d3c); /* line */ 
        coverage_0x981af3b4(0x0f44717d233c9b47ab560a9a88f84b62cb83e85950109ef3d66b16b7f3030267); /* assertPre */ 
coverage_0x981af3b4(0x23f7eca974ecbe00235ef93859a6f25e156fd73541020bdd85334f33c8491cdb); /* statement */ 
require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");coverage_0x981af3b4(0x3b8d2e7cb4cd30deb9305b5ec328614e51026b0b549d32b7d79bce9e49f20d3a); /* assertPost */ 

coverage_0x981af3b4(0x3117742d69e5748afdf746ebb24b4d806a8e04d8e5c140ac49f5485b526efa21); /* line */ 
        coverage_0x981af3b4(0xd31355f32207bc380e55306a415783d5d5007151d9d241329c225664ceb1d8c1); /* assertPre */ 
coverage_0x981af3b4(0x0d308664579cb389571e6030b41ef71454831304d0a9d231d397aec0693205a8); /* statement */ 
require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");coverage_0x981af3b4(0x4b9ff3eb4d055fcd578326daf1cb10e550ef1021428ad708fa19ee3ec8b5e2bc); /* assertPost */ 


coverage_0x981af3b4(0x9c6720e7b74142bf4b3ec00a6c0e2d44c385d85434b5dc5643bb380677fa39a8); /* line */ 
        coverage_0x981af3b4(0xcf65999e14aff42ddec0e88fc35fd64301892e90813d5b44de86363018efc2f4); /* statement */ 
bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
coverage_0x981af3b4(0x79d847af07a15c49f38be813ba7f3e95cd3bc72cf49ccf12ade81ce55ebc4c54); /* line */ 
        coverage_0x981af3b4(0xe486a14d0f4a7cd8b1b77c40d74feafd9a0630c11ec3467634f4af075325b6df); /* statement */ 
queuedTransactions[txHash] = true;

coverage_0x981af3b4(0x8296428333d9ffdd873cbfc250ab8eb144815d68dfc0954fb37d009aee01b8b2); /* line */ 
        coverage_0x981af3b4(0x91c3d0d6b03c02f8cb3f7cdd9c909a145a597c131f68c571d69e27c5ef70ceb7); /* statement */ 
emit QueueTransaction(txHash, target, value, signature, data, eta);
coverage_0x981af3b4(0x34fbcdc11c0a73e793f87cecad8a68e51067556600a94ba312f75e36e0407c8c); /* line */ 
        coverage_0x981af3b4(0x9668531d4a365f6b5b4ccdd7ba3c08a8f8356daaef8909c4412f2a6a800328a6); /* statement */ 
return txHash;
    }

    function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {coverage_0x981af3b4(0xf4d2963c0f08f729dd2913fc0d820d069fbd781574ad3ba3db216b2c7b0610f4); /* function */ 

coverage_0x981af3b4(0xa78bf817af91a202227279d714f0a3999fb94fad1b6dbabb130ac0eabd3f3e53); /* line */ 
        coverage_0x981af3b4(0x3f235778c5566018c92ca6a6543715a6b06a3e0947c2511063bff4a2ba243658); /* assertPre */ 
coverage_0x981af3b4(0xbb8cf19f5774a93098a447bbf03efdbe53489ff3ac118e25415977267d01cff5); /* statement */ 
require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");coverage_0x981af3b4(0xe8bec33fd810c3e0a85f51bd208198f015e6a96a926b5dd467e3e886fa91d841); /* assertPost */ 


coverage_0x981af3b4(0x44f2845d6cbf46c992eb1b4ec53e284b3cdbfa30b91db84896c9903cebd22a1d); /* line */ 
        coverage_0x981af3b4(0x8ef6db57e171775c163102003e83669a2c1449f12b6b05c8c15c3e8fee2af28c); /* statement */ 
bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
coverage_0x981af3b4(0x22844aedf661a89fcdbe81e5f8d213c67cd6e5c3796e54e6b148b12b99a498b1); /* line */ 
        coverage_0x981af3b4(0xfdf738015200a0707ff1088b771c95bf6a168f30889503f64996c42ce8ff2007); /* statement */ 
queuedTransactions[txHash] = false;

coverage_0x981af3b4(0xd15d3cc109015fd65fc49e85066d7e133e08af13a0f80d163d5ebc1e23b21273); /* line */ 
        coverage_0x981af3b4(0x54f027d5123e546f27798ce808854c4345cdc5462e451df7a8db7e85584ee24d); /* statement */ 
emit CancelTransaction(txHash, target, value, signature, data, eta);
    }

    function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {coverage_0x981af3b4(0xa15464c676be079744a814e0f9285cdabe5b03bc911cf462cec1592dd99bb205); /* function */ 

coverage_0x981af3b4(0x03f8309aa84caba8b55c22c29756b45867a1021ac974d9f6d788fa718c34fed0); /* line */ 
        coverage_0x981af3b4(0x1def40476bfd29f534b780fbb3e72aa438c74fd8b96dde38848f8c92df9821e5); /* assertPre */ 
coverage_0x981af3b4(0x8951587fa86ad8932d3b3e13973ddbd0a7593f2c8b3b89f577044a1c0c73c482); /* statement */ 
require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");coverage_0x981af3b4(0xf746dbc83bf5ae08ebd7dc489610f4ccc9795066ba3396fc06e188528c408324); /* assertPost */ 


coverage_0x981af3b4(0xe3fc4cfa044c6f34177c5d1573ca34806cc2163ac7492020231a40d991ef6e51); /* line */ 
        coverage_0x981af3b4(0xd6188b1b1995a7d05b37060abebd74e3fe178289e9754e9bff02755efab78bbe); /* statement */ 
bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
coverage_0x981af3b4(0xab4b50a8d7bf4b7f9f9504072f3870da7906c9a8a1fa8985527cdbf7dd2697ec); /* line */ 
        coverage_0x981af3b4(0xb076cd6d5ef93a30ef37bf8c1a6b7bcbade909f6b7b5558f37b599068163e3fc); /* assertPre */ 
coverage_0x981af3b4(0xaf91e4975f3f1ff85c9cdd290d630f3afbdcc7a74d81a0e7f371df24f257425d); /* statement */ 
require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");coverage_0x981af3b4(0x8ac357141963c9fb517068ba9f4327800d3861ecc5492c1a229d1400e46523b7); /* assertPost */ 

coverage_0x981af3b4(0xc9be5cb75ea053cc4f7bf8620a2567b86afd9f5846f71665d345b52f40d9af65); /* line */ 
        coverage_0x981af3b4(0x7bf593ecc9505d68a03a5b2edec8d41d04474a234e3a95a7fa17d7f4bf770233); /* assertPre */ 
coverage_0x981af3b4(0xf0f92a35c0de1abaf7a5237cbfbed58f91d9c8505a0c8b3482d5fd193404a267); /* statement */ 
require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");coverage_0x981af3b4(0x765e10d5a72c8a6a182c2a9f91a3fe057ce4fb1862a4f80906e8fd03c0d4e69b); /* assertPost */ 

coverage_0x981af3b4(0x9edabd8e7873dffc48cd2958d484462bb8c30b4ccafcd37157aebfaeeff3e8a9); /* line */ 
        coverage_0x981af3b4(0xc2d00e1c5b3b911adfad537e60fb0a7385dda9071c47090cdda585f3924a29ed); /* assertPre */ 
coverage_0x981af3b4(0x8dedb1962626d46572c4f2e0256916694ca2749e103c4f024302297beac1545b); /* statement */ 
require(getBlockTimestamp() <= eta.add(gracePeriod), "Timelock::executeTransaction: Transaction is stale.");coverage_0x981af3b4(0xe578f3308716307265d6907a219e425056a88ee0573f0bbc175b1c4631ce3a02); /* assertPost */ 


coverage_0x981af3b4(0xeec20d4b157831aa83718a49c5d2e5f9e85e4930d28d55c30c9bb115fa592b9b); /* line */ 
        coverage_0x981af3b4(0xd5c1f0d4cf85aa0d0058199b1f2079104bad86bffddad773aee3ddad42634b49); /* statement */ 
queuedTransactions[txHash] = false;

coverage_0x981af3b4(0x120b51cb0b76272c09fc75c3737481bf9a3fda365a0219a8b999518cb8dd5df9); /* line */ 
        coverage_0x981af3b4(0x8b112c2be3db0b50af3e928e6bce484978ddad206e67507ff36ef5d80eb73233); /* statement */ 
bytes memory callData;

coverage_0x981af3b4(0x7ab0f8af53d907bfcb2ce2363acec3adf00a6c40d407e536c95c14a117fe0684); /* line */ 
        coverage_0x981af3b4(0x7c150dbd78432b81a0a01e0f2952a5ca969f1944b95154c7038c19de5204274f); /* statement */ 
if (bytes(signature).length == 0) {coverage_0x981af3b4(0x5c535a21ad8e994dce34bc58c2c7eb6dae92b3189a418fb82a6442cba3e71149); /* branch */ 

coverage_0x981af3b4(0x3c5c746d69e727f0e97a8d29d36a979cd623dfbe6aca107559b0bf29c2cef17b); /* line */ 
            coverage_0x981af3b4(0x3cfd9b25983a4555ced76612d72ed0eb519840a510f63c4f6bbde71982f1e85a); /* statement */ 
callData = data;
        } else {coverage_0x981af3b4(0x3bd77ba6ed79d727aacd9021016cc5bbfad114799cab2c4bc4e0b51e7d50891a); /* branch */ 

coverage_0x981af3b4(0xeba4d0548f991c9231e3847f0e64fa2269755901adebb0ec6e7f7de4602a05bf); /* line */ 
            coverage_0x981af3b4(0xf507783deb2c08473441a1628f56a9e861aa7e5491d9b4f545f726960e517c0e); /* statement */ 
callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solium-disable-next-line security/no-call-value
coverage_0x981af3b4(0xe31a9e52cafa0b0b80939dc561c2450b88dc795fecc72a4d0fe4068d95312003); /* line */ 
        coverage_0x981af3b4(0xeaebe9bfccc2cdeaf9b3546a78127c5f74ce2f85fe7da1e770339aac5b9f2080); /* statement */ 
(bool success, bytes memory returnData) = target.call.value(value)(callData);
coverage_0x981af3b4(0x7006838ce470c0fe1eaf1a5f0de065d73fb4dac3294507bdabe691137acf07c3); /* line */ 
        coverage_0x981af3b4(0x364d1f407b7ab6bc4fa0e568104f3304bc84e1886ffb05dc72ccde19bd7360d5); /* assertPre */ 
coverage_0x981af3b4(0xbfcf86f49c5debd3f5cf2c98b0cf7d24443463e6d2f4af7a2e72fc1477bd5783); /* statement */ 
require(success, "Timelock::executeTransaction: Transaction execution reverted.");coverage_0x981af3b4(0xdc98c6a08248749060ab2f64060b101044072c7a00ca92aa9edaf534cb88e289); /* assertPost */ 


coverage_0x981af3b4(0xfe547b554a9b1c9e159668f97abcfe1d643992f7128872bc24f50241c1ba5988); /* line */ 
        coverage_0x981af3b4(0xeb042fa1f684a1b38ce2a406d06effd2c548d75758f1ccc34f0d14cd23b32dc1); /* statement */ 
emit ExecuteTransaction(txHash, target, value, signature, data, eta);

coverage_0x981af3b4(0x2bd08e9e68da14f2a630be7d2b9055eed74b5ac8d10e79f62147343c140db62b); /* line */ 
        coverage_0x981af3b4(0x2d8bef8acfd6e3365c8a7a2552cf9ca12dc0f5a9c2f9a1ee57e0803d362e3c1b); /* statement */ 
return returnData;
    }

    function getBlockTimestamp() internal view returns (uint) {coverage_0x981af3b4(0xfd20447c916f1c9eb942fa0339979f71e36baaa6acd4c92ad70305bd6c05aea3); /* function */ 

        // solium-disable-next-line security/no-block-members
coverage_0x981af3b4(0x776300744a7cfe2a4d63f0968720b8e276e48c9b46fd56dee5a7ee20adba035d); /* line */ 
        coverage_0x981af3b4(0x8234bad322eb2488dd8b71b57cc678adbe39349020d0184f4f4ac623c959d162); /* statement */ 
return block.timestamp;
    }
}