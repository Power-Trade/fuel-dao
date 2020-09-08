pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

// Copyright 2020 Compound Labs, Inc.
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

contract Governor {
function coverage_0x020835f7(bytes32 c__0x020835f7) public pure {}

    /// @notice The name of this contract
    string public constant name = "Sync Governor";

    /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
    uint public quorumVotes;

    /// @notice The number of votes required in order for a voter to become a proposer
    uint public proposalThreshold;

    /// @notice The maximum number of actions that can be included in a proposal
    uint public proposalMaxOperations = 20;

    /// @notice The delay before voting on a proposal may take place, once proposed
    uint public votingDelay;

    /// @notice The duration of voting on a proposal, in blocks
    uint public votingPeriod;

    /// @notice The address of the Timelock contract
    TimelockInterface public timelock;

    /// @notice The address of the SyncToken contract
    SyncTokenInterface public sync;

    /// @notice The address of the Governor Guardian
    address public guardian;

    /// @notice The total number of proposals
    uint public proposalCount;

    struct Proposal {
        /// @notice Unique id for looking up a proposal
        uint id;

        /// @notice Creator of the proposal
        address proposer;

        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
        uint eta;

        /// @notice the ordered list of target addresses for calls to be made
        address[] targets;

        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
        uint[] values;

        /// @notice The ordered list of function signatures to be called
        string[] signatures;

        /// @notice The ordered list of calldata to be passed to each call
        bytes[] calldatas;

        /// @notice The block at which voting begins: holders must delegate their votes prior to this block
        uint startBlock;

        /// @notice The block at which voting ends: votes must be cast prior to this block
        uint endBlock;

        /// @notice Current number of votes in favor of this proposal
        uint forVotes;

        /// @notice Current number of votes in opposition to this proposal
        uint againstVotes;

        /// @notice Flag marking whether the proposal has been canceled
        bool canceled;

        /// @notice Flag marking whether the proposal has been executed
        bool executed;

        /// @notice Receipts of ballots for the entire set of voters
        mapping (address => Receipt) receipts;
    }

    /// @notice Ballot receipt record for a voter
    struct Receipt {
        /// @notice Whether or not a vote has been cast
        bool hasVoted;

        /// @notice Whether or not the voter supports the proposal
        bool support;

        /// @notice The number of votes the voter had, which were cast
        uint96 votes;
    }

    /// @notice Possible states that a proposal may be in
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }

    /// @notice The official record of all proposals ever proposed
    mapping (uint => Proposal) public proposals;

    /// @notice The latest proposal for each proposer
    mapping (address => uint) public latestProposalIds;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the ballot struct used by the contract
    bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");

    /// @notice An event emitted when a new proposal is created
    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);

    /// @notice An event emitted when a vote has been cast on a proposal
    event VoteCast(address voter, uint proposalId, bool support, uint votes);

    /// @notice An event emitted when a proposal has been canceled
    event ProposalCanceled(uint id);

    /// @notice An event emitted when a proposal has been queued in the Timelock
    event ProposalQueued(uint id, uint eta);

    /// @notice An event emitted when a proposal has been executed in the Timelock
    event ProposalExecuted(uint id);

    constructor(address timelock_, address sync_, address guardian_, uint quorumVotes_, uint proposalThreshold_, uint votingPeriodBlocks_, uint votingDelayBlocks_) public {coverage_0x020835f7(0xcbdadf23775a62d76733d2b266761c02c962ed577f5f74fd6ffeccfa10dfb35f); /* function */ 

coverage_0x020835f7(0xba4ddabf9e20fff4f9b5cb6a60457f0cb5975c915b3f6a2969b7b7e6140a2b4d); /* line */ 
        coverage_0x020835f7(0x66a88a234bab1770d4ee143f35ff59012c7488f728745782fc1a317684672f70); /* statement */ 
timelock = TimelockInterface(timelock_);
coverage_0x020835f7(0x59c8c682cac712f2d1ccf89497e41e787e5e147d9fa4bd8e5f78ae3ca4826496); /* line */ 
        coverage_0x020835f7(0x3cef4a59bbd27286490ab9ca3ae5e9c10cccf72e6a8d13611e0608c808c8791b); /* statement */ 
sync = SyncTokenInterface(sync_);
coverage_0x020835f7(0xbd519544ef3a2f4f1c3ed244837687e9e463678cdb0622376be310b73eee3365); /* line */ 
        coverage_0x020835f7(0x33fd4ddc5831d97eccbb9c57d5037b124331f0119df2ce8e7de402a695c91310); /* statement */ 
guardian = guardian_;
coverage_0x020835f7(0xa4d64ca591a5784cc19ed51562cce9d574b09fb91e2a3b347da65ff40d3ef9fc); /* line */ 
        coverage_0x020835f7(0x644fbd0334262aefda9230874879692204fcd3919a9c731cfd112b43a26d7cc1); /* statement */ 
quorumVotes = quorumVotes_;
coverage_0x020835f7(0xc970a221e6e98250cff760116219ae9893867d89a3e17300f459d86016b8201c); /* line */ 
        coverage_0x020835f7(0xfca9a564dada8d6c4165e5e1ed29a1dc6ec6c167786e0d6818eb3881452fd90c); /* statement */ 
proposalThreshold = proposalThreshold_;
coverage_0x020835f7(0x676c126f14cf32028c5b9b966724497aaeadc014c1b71baa152c8a15ea598c44); /* line */ 
        coverage_0x020835f7(0xed804009e532036a4a1832091616e025e334cc9a7353e02df74f1c14f7664ce1); /* statement */ 
votingPeriod = votingPeriodBlocks_;
coverage_0x020835f7(0x4bef439b029b23d5d843ac72922244684afa9f1b575638e258adc2c9cc789b1b); /* line */ 
        coverage_0x020835f7(0xc39afcb7b7798368993d292640c1693e4d739a20133dda7beca36ecfd1fdf1df); /* statement */ 
votingDelay = votingDelayBlocks_;
    }

    function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {coverage_0x020835f7(0x12ea46598a84db7ed89a9c6808c2407ef3874a27ec37a41372a7c7d66dae5618); /* function */ 

coverage_0x020835f7(0x5408a176e7de9feddb2f3c3779324745651ba4e9e4c1d78c2110bb3f22791a00); /* line */ 
        coverage_0x020835f7(0x6dc7ed2141e3bbf008c5394cbfba4b7012f3b7d5a7271121e989c8b6cd0bd708); /* assertPre */ 
coverage_0x020835f7(0x16f5c59bad5253868ef17c3ac7f647021326fb2740cd7607c52708283b3591c6); /* statement */ 
require(sync.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold, "Governor::propose: proposer votes below proposal threshold");coverage_0x020835f7(0x77048273a7449f73924f26453f27a6d3d40f110c5111e4cb62427afccfdcb393); /* assertPost */ 

coverage_0x020835f7(0x9635ce78e110eb42137775e2d6280c0ef34afadaef8fc3e97371a5a5b17fec65); /* line */ 
        coverage_0x020835f7(0xf14b98a9498f8d32ede0d37b578aa9c5a3474ec5733a738dee4b641879311675); /* assertPre */ 
coverage_0x020835f7(0xc7dd88ab7a07aac83e18a5e9774de3353b9bc63639a9331b79940da28ca61b2a); /* statement */ 
require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "Governor::propose: proposal function information arity mismatch");coverage_0x020835f7(0xc7da5094f06cf5923365a97f2ebb89e7cb7a56d6c5dbe25f76364592957e5ead); /* assertPost */ 

coverage_0x020835f7(0x279275832215d1f63a83be3c65502bc4e1de20381f1d19bd20e8fc18bc0996f6); /* line */ 
        coverage_0x020835f7(0x6e14675ba6a45fb13eb309bfb723c74a914a68e5b1981695f0bb8c54bae6182c); /* assertPre */ 
coverage_0x020835f7(0x4c183e7613238467a2bd6f9c6c0d6904f19dca2fc0a144065b37aa8648d001e8); /* statement */ 
require(targets.length != 0, "Governor::propose: must provide actions");coverage_0x020835f7(0x5b2464d8adcdd0686da4edef76e6c837481cd965a9de3f7156c92aa148cc05cf); /* assertPost */ 

coverage_0x020835f7(0xb59b1e63c154b66b7c1e6ea5b209d3954a71f22f2a547020def5bb6c4bd93be5); /* line */ 
        coverage_0x020835f7(0x969fb9fc052164c7cbacafbf3d5485e6221e21e9c6fff9deeddbb024a922f1f9); /* assertPre */ 
coverage_0x020835f7(0xc4bc256775e57964e0d1fdb2fe0beb2ab1200a8a087772b49c7960e131e3b162); /* statement */ 
require(targets.length <= proposalMaxOperations, "Governor::propose: too many actions");coverage_0x020835f7(0x3211cb0826616690b67fb1d08fdea9711ac1bff6909180278e275049ff46fccf); /* assertPost */ 


coverage_0x020835f7(0x487dea7bd424a13d39b486d293d5c6ba6051db6125fabeb5abdefc1ef9b1b2f6); /* line */ 
        coverage_0x020835f7(0x18e1c04a268bc44e86295bd17414034a78aec497fa0074c2f4ce832e64a27332); /* statement */ 
uint latestProposalId = latestProposalIds[msg.sender];
coverage_0x020835f7(0x2c2a4067054827e280d2c5310cb653f70cea060b40afe14ce6bd25ce6d120fad); /* line */ 
        coverage_0x020835f7(0xbe72d31419eeab99c2512e097f1555f3f14d4cb49b4bc20faae55d9555731ed4); /* statement */ 
if (latestProposalId != 0) {coverage_0x020835f7(0xeb74178336139aa80b6f2f22e5bc39f4009a1036a8686fead0844733542ac01d); /* branch */ 

coverage_0x020835f7(0x27dca9cc90fe270b8a40a1cadf4f7de615d24ba7ff73ab7c2e67c4bb62e737bd); /* line */ 
          coverage_0x020835f7(0x2f00e2ac8618aeb8bb957c1127bea1a1b78cbd238902825efadd3726d535acd6); /* statement */ 
ProposalState proposersLatestProposalState = state(latestProposalId);
coverage_0x020835f7(0x2a6dec63ca405ac51b59ae702bbda2ff3271e3c121238d20f691ba6fd53227db); /* line */ 
          coverage_0x020835f7(0xb107671f702a2b9e1c8b02d1d2fc993f6177c938f5bbdd8c5d8414c5dd43f325); /* assertPre */ 
coverage_0x020835f7(0xdabb92fe0899a8d5add9d843082a5b0bdf59cfea077335362fa3268a0d6ed78e); /* statement */ 
require(proposersLatestProposalState != ProposalState.Active, "Governor::propose: one live proposal per proposer, found an already active proposal");coverage_0x020835f7(0x898bf4a6379d7167ee42e380f677e9460a4699de0ddd296ba65de24150043f46); /* assertPost */ 

coverage_0x020835f7(0xd2ba66a0639c94c4c5d2c4d983e31e4f457f792454e8cb4a7963c6f2e6fd8729); /* line */ 
          coverage_0x020835f7(0x92edd6247e5c1d51f0b267871fd73cabd3e446af9ede5d08f315d32abda4ee25); /* assertPre */ 
coverage_0x020835f7(0x63b3d773f06b580348734e1e8b3eec1b1f52547c6cbc23f57c27528062b7e02f); /* statement */ 
require(proposersLatestProposalState != ProposalState.Pending, "Governor::propose: one live proposal per proposer, found an already pending proposal");coverage_0x020835f7(0x2235db403a0b79205ce9be2bc594740c4ff19a1f725b154166d4b7ad2e97ec96); /* assertPost */ 

        }else { coverage_0x020835f7(0xc07180d55ce67ece853678c83dfd18359a4ecdc9896c47bd26abc9ec9f735121); /* branch */ 
}

coverage_0x020835f7(0xc5ac4f1b49494157f1b20df7e728330e64135be02e9e5151de892d0c1e130262); /* line */ 
        coverage_0x020835f7(0x7ea4b53f4e4bfd85e65bc8dd162c7080f474a21f642e53e18d05e27d0c1f247f); /* statement */ 
uint startBlock = add256(block.number, votingDelay);
coverage_0x020835f7(0xa1e91c5467768adea80e2784af03b999fbd6a7b2bc1a98249c497a09f2ab5e9b); /* line */ 
        coverage_0x020835f7(0x6f1ad5488b011c490f7790c4cb6f55ebf622f5101918a5d689a6fc1e53a7ca3d); /* statement */ 
uint endBlock = add256(startBlock, votingPeriod);

coverage_0x020835f7(0xbc18aae6a6ff91bc112ffc139b37fd445bd4f9bc26b8ffc46f9e49b93f69390e); /* line */ 
        proposalCount++;
coverage_0x020835f7(0x4d1bb153152555d729a838f19d5b649fb2a2a7f04e325258b8208d2f8471f776); /* line */ 
        coverage_0x020835f7(0xadaf8b01712d351d210faac95be14847779b3316f7cb1b9d7bde3301f315cada); /* statement */ 
Proposal memory newProposal = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            eta: 0,
            targets: targets,
            values: values,
            signatures: signatures,
            calldatas: calldatas,
            startBlock: startBlock,
            endBlock: endBlock,
            forVotes: 0,
            againstVotes: 0,
            canceled: false,
            executed: false
        });

coverage_0x020835f7(0xee484580aae12712a2e15a9a71247936c3ffe423410ff4652895a3d1a4d0a97b); /* line */ 
        coverage_0x020835f7(0x75e2f7f7e55894e61d1d50192a90a03fb52cac8c40ace613be6628dc5c22bc3e); /* statement */ 
proposals[newProposal.id] = newProposal;
coverage_0x020835f7(0x21131234b07f4f313ff80a0f29749880c11ed1bc85345a9941b032465a1bee37); /* line */ 
        coverage_0x020835f7(0xcd949ce80ce6bacb5ac2f6a6981d8887304abd14a7a9fe46efe0cb8c6a7765a9); /* statement */ 
latestProposalIds[newProposal.proposer] = newProposal.id;

coverage_0x020835f7(0xd8a883e4f1e475573f3216e7f9f1051902e254e03a1933e6143e7704407afd6c); /* line */ 
        coverage_0x020835f7(0x25a4785e7fb2b0f62d2fd8aaceeb3f45f7cb3bc85946e01be45829ba284f010e); /* statement */ 
emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
coverage_0x020835f7(0x784ad98b4401e6d79a2bdbfedcc2e4209665b582b3e891f83d0a8fcc3ede1e5f); /* line */ 
        coverage_0x020835f7(0xb76bbd93987c0e4dfabed7056a5dbe61411df3530c7e985c3eeef0519ffcd8e1); /* statement */ 
return newProposal.id;
    }

    function queue(uint proposalId) public {coverage_0x020835f7(0x9dd82745f05ea93856e9507864e2b46fbbf23d50498255c4960405a147abad35); /* function */ 

coverage_0x020835f7(0xc6bcd508dde96c72f73a881506eede8fe116af944e07f57ca3ca05ad90fc4e90); /* line */ 
        coverage_0x020835f7(0xfdfb7ca87d18052b7b441e653cf5da9744792497038feb8436942ece763bc67b); /* assertPre */ 
coverage_0x020835f7(0x47633af5189855c444fc892c9ae06713c8d69812176cc9c906706c97aab44fa4); /* statement */ 
require(state(proposalId) == ProposalState.Succeeded, "Governor::queue: proposal can only be queued if it is succeeded");coverage_0x020835f7(0x9852579687e981069a9264190348a996e17b0236701f43bbbb99a9de9a3332fb); /* assertPost */ 

coverage_0x020835f7(0xa4614bba832655fa7a9a6c4f40a6be6917b5eb3547bf295c1d630a5496cec337); /* line */ 
        coverage_0x020835f7(0x8a7ea8266b983bbe355f0e52bf8185a93021c930b46d2e338f6e9ff7a3b1df96); /* statement */ 
Proposal storage proposal = proposals[proposalId];
coverage_0x020835f7(0x874eb410217fb70a361386162a80ebf665c99f34aa02b50d9eb4fd2a22c4e9bb); /* line */ 
        coverage_0x020835f7(0x945243f476efc159b8dd6435014448f1cc441b51809a2345d04e01d6744fd51a); /* statement */ 
uint eta = add256(block.timestamp, timelock.delay());
coverage_0x020835f7(0x4a94a8fc03f670ea2030cb1c2b9f099f19cac6cabed467ce49cbeb1ef991dd4c); /* line */ 
        coverage_0x020835f7(0xd4f1705888644367a217f0f6b181cc55636184ad8bb72f7a9b32d86f0170e832); /* statement */ 
for (uint i = 0; i < proposal.targets.length; i++) {
coverage_0x020835f7(0x507383d0154cbb5e9130f8adf7a524186e321e1eb03f40091e572afd8e9112ad); /* line */ 
            coverage_0x020835f7(0x581344072e10ef92ccd7d260186d201e0124cc1caee27705a6382513c2354da5); /* statement */ 
_queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
        }
coverage_0x020835f7(0x00f4e48ee987029c8a5126c02d8be6939657f9ff42a296de9df257d87eaa25ae); /* line */ 
        coverage_0x020835f7(0x628deeb72e89d44b1ab0f713df8e6d9ffbb29d79bbdd1d4f59993528709e7db7); /* statement */ 
proposal.eta = eta;
coverage_0x020835f7(0x7777d01956c7bf91b74ac1a808434b05db9165d73de52c5f55eb07b547051300); /* line */ 
        coverage_0x020835f7(0x168b5d78082bac29b9bcdd71019567037976070ee909a20cd01c9b9552c9f610); /* statement */ 
emit ProposalQueued(proposalId, eta);
    }

    function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {coverage_0x020835f7(0x6b635e44fddd53d525eeb49820cd99ae626377a063917320040df43c9e4acca5); /* function */ 

coverage_0x020835f7(0x7c79f02e3ea3ada1a059bfa23367d3f9d7cd7b701397d5c5fd4192c6f612972b); /* line */ 
        coverage_0x020835f7(0xb248c9f67654d28d5c7d297874619061822a5d567235f00765c155e16ee141a3); /* assertPre */ 
coverage_0x020835f7(0x7d813ff28459c8a4a2e6afc3fc40ede7468d1a5eb6c8db25ba338a57ea80ca6b); /* statement */ 
require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "Governor::_queueOrRevert: proposal action already queued at eta");coverage_0x020835f7(0x71c8e1dc2c53dbb1a264614f09c00962fa5c96e9c421e38c1f8ea7bcb452aece); /* assertPost */ 

coverage_0x020835f7(0xb9df50cff9721e6bf6cafaee2e8f065b60c65be28a703b2767c6b06c142df106); /* line */ 
        coverage_0x020835f7(0x70502917cef40b8322f8a447ca50802baa010654e4ac6f2dc8064638b0357372); /* statement */ 
timelock.queueTransaction(target, value, signature, data, eta);
    }

    function execute(uint proposalId) public payable {coverage_0x020835f7(0xc4a6fa32bccc4457025bd0fe8e2b647a2a51f7a60056bb77daf8087170806ea5); /* function */ 

coverage_0x020835f7(0xa9e9f65314553d6281a5d98b2c8c8ffc22d828b04dde93d9aac89164409a24b6); /* line */ 
        coverage_0x020835f7(0xb80b66c9c578876deb30e89d6f10c14950c4755f43bb2b4ea3d237664e0da934); /* assertPre */ 
coverage_0x020835f7(0x161780509a771b40aa5877535b281276d6a6931a30993da96a4545dba92360b1); /* statement */ 
require(state(proposalId) == ProposalState.Queued, "Governor::execute: proposal can only be executed if it is queued");coverage_0x020835f7(0x5bc8ed1535509409bf14fd5b20de2fdebe9f9d2831623b43054e28f16558f500); /* assertPost */ 

coverage_0x020835f7(0x3165e2426ee9fdc136802be7854b20a25f941dd209be6808c2c71ce5fb84d86f); /* line */ 
        coverage_0x020835f7(0x80f8d0f507ea766e56a75782e19a03cbda2982434c047218d3ba5ae5081b246c); /* statement */ 
Proposal storage proposal = proposals[proposalId];
coverage_0x020835f7(0xfe7a42c2ab7422625bd2a4e0f3d605983515a06ba36b7a100a74bb9f3384c1ac); /* line */ 
        coverage_0x020835f7(0x206e08ad1dcf6134ddbd47f82b956a8a1063b9c17d7953eff7652cb4936d32d9); /* statement */ 
proposal.executed = true;
coverage_0x020835f7(0x2dcca6bc6a474af3b928c48a3d292cd9f5695e18898f40e5af98acef227e853b); /* line */ 
        coverage_0x020835f7(0xf674370baf656bb98ed6a0054b92d3d50a574d7587d158dc6d90083fb49cfc77); /* statement */ 
for (uint i = 0; i < proposal.targets.length; i++) {
coverage_0x020835f7(0x09c990297d1efbd200b424f596c54ce763d931a655b827ff4abe919a683b1fcf); /* line */ 
            coverage_0x020835f7(0x988f593786862f168ad39cc48f321f30980de9b23bd0de67a1d4de9d3d54c8ee); /* statement */ 
timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }
coverage_0x020835f7(0x6a8ecc067ec7a1870041e0f515a73b258fd35418b02b906910c6cdc163f04173); /* line */ 
        coverage_0x020835f7(0xf523b3cfc6e65cacfbcf12b98f7521b6c5f9a38f9cfd3b86cdc15a292c45a0dd); /* statement */ 
emit ProposalExecuted(proposalId);
    }

    function cancel(uint proposalId) public {coverage_0x020835f7(0x35817ea6db27cb213b21ef2a3bdf2e86738369d3ebcde74b907236e27d4fd64c); /* function */ 

coverage_0x020835f7(0x7ceb55f990a5719e93b3540a966b0480090ec143e0689dd081ebe68e01024d93); /* line */ 
        coverage_0x020835f7(0x4976dff6da1b83b93c79ddcf4cc3b0308328ee5fb1025d2d3bdcc3aa02adbc4b); /* statement */ 
ProposalState state = state(proposalId);
coverage_0x020835f7(0x8066ad7eaa69e5a40bafd1990a33d9df34c852d9f45fe5f6a686807927ebb806); /* line */ 
        coverage_0x020835f7(0x3e8aaebe57bf1d7df48a6eb14ed4ce6e95cfe21d59c7b91c1e6bf3289911192d); /* assertPre */ 
coverage_0x020835f7(0xbac3314d8407f4ce2b570ca0ac45ea2fd4b02fc23a6a78bd8f643a8165ff9502); /* statement */ 
require(state != ProposalState.Executed, "Governor::cancel: cannot cancel executed proposal");coverage_0x020835f7(0x0ab684e88384be2b9a486cc8ec533bb8f9da9dfd287769b47b5d78a5750c5c47); /* assertPost */ 


coverage_0x020835f7(0x62614d6bdf51712332921c577f612c879cc1d0d44c05e39e6d6c7235608d78aa); /* line */ 
        coverage_0x020835f7(0x37ec3994e73e588062219b2ae9adcf772adc62ec5f74d9a533aba24891a3b7bf); /* statement */ 
Proposal storage proposal = proposals[proposalId];
coverage_0x020835f7(0x5bb56a881f19892048e80767b0c01f17e7e6a2e6cdffdc99b865a6a050beed66); /* line */ 
        coverage_0x020835f7(0x36278d6b5f404e49208be5b5efd174779b27b49191922cdcff081b7c8e20f1b9); /* assertPre */ 
coverage_0x020835f7(0x3d64a31dd19f58ee6810e36a201cce7298119a9c3b2f396240715fea766a632e); /* statement */ 
require(msg.sender == guardian || sync.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold, "Governor::cancel: proposer above threshold");coverage_0x020835f7(0x54a67fb5553769782966d02dec9c350bb3a594345527a8a40b065bbca4b94faf); /* assertPost */ 


coverage_0x020835f7(0x46246100073b2ae8bbd89f05ad5b76f4ecd1de4f92642a8c0e393dac42c8a6ca); /* line */ 
        coverage_0x020835f7(0x4b82f49b95f110cd45535efd598f106392b94828d947aaedcaf70e3a512e45e7); /* statement */ 
proposal.canceled = true;
coverage_0x020835f7(0x1f989d54ee4739eb8d5ac991e4e834e8d8de24392d71419ea528f0ae36826b19); /* line */ 
        coverage_0x020835f7(0x6c1dd0a847fe35bbb9d880c0473c6b5478d016185ec7326c556daa6599354bd2); /* statement */ 
for (uint i = 0; i < proposal.targets.length; i++) {
coverage_0x020835f7(0xefbc411b346b31ebeff4e5d7109c94b8c6016724ca24615b80cbce8101500619); /* line */ 
            coverage_0x020835f7(0x1e6947d4625563f0749aad49a347fc34f70d4bf74f6c1bb948b7a81d9dba0e82); /* statement */ 
timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }

coverage_0x020835f7(0x94e282f2d2b8e7f85f8402434d0e6a63245d5ecf3507c102e2a00ee273bb5373); /* line */ 
        coverage_0x020835f7(0x8fdf9d0a2ef61cfc7cf6814dd25a01a7ab3f53c09a96f19c0b06e123c5df2b7c); /* statement */ 
emit ProposalCanceled(proposalId);
    }

    function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {coverage_0x020835f7(0x5c8eba731846f5b2319125087c319cfb296d1986d51ad3e5eb3a5057c5e9a97b); /* function */ 

coverage_0x020835f7(0xb83c81dbdbe7ebcc6aed5f78708606ba27e15dd58a72769c12d2585c72b487fa); /* line */ 
        coverage_0x020835f7(0x1bb2babd0fdedaad225719fceb2928f59259297ad367cafd2bb7c81d41e74371); /* statement */ 
Proposal storage p = proposals[proposalId];
coverage_0x020835f7(0x7caaf9761c2fc799e8eaf1d089b6304f1c99b26f17e8864f3a6e708bcb513a57); /* line */ 
        coverage_0x020835f7(0xe0e591b4abea8a05c1e4cd0ee3a4b44456a28efa4744ad16190b705781852e54); /* statement */ 
return (p.targets, p.values, p.signatures, p.calldatas);
    }

    function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {coverage_0x020835f7(0x3e4a1e5e3b4f2f0efbcbef917c77e952c1ab4aa1badfa9713e0689d1ff422427); /* function */ 

coverage_0x020835f7(0xa70e4d7351867ce7416912d0a8659a553da6c9fa45a35b1f53c11bf5008f7b2a); /* line */ 
        coverage_0x020835f7(0x5a6cb457a820c57db870597b9591858a05f8d3ec91103c95f73a2fabe66fcaf6); /* statement */ 
return proposals[proposalId].receipts[voter];
    }

    function state(uint proposalId) public view returns (ProposalState) {coverage_0x020835f7(0x3838ef20573b0e40660c7e1f17b582c50a8f6e8f3396e9832f15b52afa21cb99); /* function */ 

coverage_0x020835f7(0x5dcd45d3e0bbeadab7fac40cc1839051818f0702b5158a5988af6e616bae36bb); /* line */ 
        coverage_0x020835f7(0x1784b1eb03bd60b9afae14cf6e10fa1f6b8c7f708827ad38cc5425b48bf217ff); /* assertPre */ 
coverage_0x020835f7(0x0f6e9f6c3d603762dec852410e1d84d43eb9eb4a371f3bc864577c02ef31792a); /* statement */ 
require(proposalCount >= proposalId && proposalId > 0, "Governor::state: invalid proposal id");coverage_0x020835f7(0x629195ffd555e6ee1c52c219100bfac7d0e3a19a592b9c93ab2894d76c728b42); /* assertPost */ 

coverage_0x020835f7(0x8287a4e72102c54ba3839658017b9697641c5dead6400dccfcf0aa6321ba43ee); /* line */ 
        coverage_0x020835f7(0x04c993ac910bc1769e077f219d37e693e1a9a578ff7d7a1650d4d167d371d14d); /* statement */ 
Proposal storage proposal = proposals[proposalId];
coverage_0x020835f7(0x284106222846e0f36169468e6a3f75bec94a69a557e1ffcdaf064709f51a60e8); /* line */ 
        coverage_0x020835f7(0x18ac98fd2fecf9310b3980de25cebcc475356a05975a022d19fbe55eddeb5e45); /* statement */ 
if (proposal.canceled) {coverage_0x020835f7(0x4e108db0d8f3a56a02f4cabca9849bd54d695284652e1e56fa8faa62d4cb7250); /* branch */ 

coverage_0x020835f7(0x0c53c135bf5cb9189ff5b930258f5b0a5dddb43640e42346b3f442407a030c3c); /* line */ 
            coverage_0x020835f7(0x727e910754022e302e53ab3664489799469e6d8b103084c288198e26a7015d86); /* statement */ 
return ProposalState.Canceled;
        } else {coverage_0x020835f7(0x6018383aac2a09260fa5a425fad4d0e6e4dce9c539af3299732d5f7a2903c26b); /* statement */ 
coverage_0x020835f7(0xea64ac0b0443db0e253b29c6bf6796f2c6a5e51b321f49f5a2bec0488eb6cf5b); /* branch */ 
if (block.number <= proposal.startBlock) {coverage_0x020835f7(0x47f0bdb913de30f47890e257aa5f0679305dbeb6eb03aa723d1fa2d5560b69e9); /* branch */ 

coverage_0x020835f7(0x78925d80dc00e110c3ee98f112c8d450afba1e24110635dab5184cde5ce511fe); /* line */ 
            coverage_0x020835f7(0xb78db461bb0752c07c896bb9503ec45bc496fc5ee632aafe28b6b077c7b04e5d); /* statement */ 
return ProposalState.Pending;
        } else {coverage_0x020835f7(0x00fd4ad4beb488aeaa1c81fc9935007fd1b71cb464bd331ad170d84020bf313c); /* statement */ 
coverage_0x020835f7(0x7057749556ec48dae5a4ca700f5ef600010ee4e8579cee1c39eba6e5bc3c7380); /* branch */ 
if (block.number <= proposal.endBlock) {coverage_0x020835f7(0xf859b53a108d159c01baedff843b06f4d2ecde751c6d691ba9814048714a0639); /* branch */ 

coverage_0x020835f7(0xfab980c7df12a50a8e52de07b2dc823bbae728aac8c61a6f1a21dbe0803c5c13); /* line */ 
            coverage_0x020835f7(0xb56cd2987598e18d4160da2b021640b5deae80c9b970c37df362a25442f944f5); /* statement */ 
return ProposalState.Active;
        } else {coverage_0x020835f7(0x9c9655437a50c7c7f336c99d447dcd14e349270b004f0a7095aa24e1f84a57c7); /* statement */ 
coverage_0x020835f7(0x822e0c62ca63c2aa1cdbd3b94fb7dbf2b58ff112b1205aec69bae1d9cef1fdc2); /* branch */ 
if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes) {coverage_0x020835f7(0xd631a83c770243bcf2f81fdaa9214c1721b92d29fb8810643e22f356c3074da0); /* branch */ 

coverage_0x020835f7(0x74a2dfdaf3ff12090ad2d2fc0e74f398ab803504f9b74c61c29dcb7e243fe6db); /* line */ 
            coverage_0x020835f7(0xde4e6f5ef285e0f1423a98c7fb201834f3bc830565eeabc63c8579dd95b7edd6); /* statement */ 
return ProposalState.Defeated;
        } else {coverage_0x020835f7(0x7fdcb520120775d0e01cd233df54e99e385db33f90629fd1976b6401aaecc647); /* statement */ 
coverage_0x020835f7(0xc917c64e2d79461e4450b12a60647d45bda7da04c623be6cd7cd59097eeeb6c1); /* branch */ 
if (proposal.eta == 0) {coverage_0x020835f7(0x957f6ea7b29d2ceb9923cd3325931e8bb6bb37cbfbe26c8311545149853294e8); /* branch */ 

coverage_0x020835f7(0x8a6eed1c49d0f11f0691803c7b9d08751257c98f48c61382eeeabfbe11abfaff); /* line */ 
            coverage_0x020835f7(0x7e24326e4556e7f0c7569cbc49f4045817a1148dbc193499a8aafb6e13d4535d); /* statement */ 
return ProposalState.Succeeded;
        } else {coverage_0x020835f7(0xbba4cd04bf58c1ad23a485d32b813fa14305fae2e712aed57906b0c240adb311); /* statement */ 
coverage_0x020835f7(0x351f2305ce868265b73f07c81dfbe95057a5382c0f80afc30e9397345c46117f); /* branch */ 
if (proposal.executed) {coverage_0x020835f7(0xf9f6a341b64de2aee0409867551733fb6b874ff70e563706be13118280ed1047); /* branch */ 

coverage_0x020835f7(0xc9446a1fc604a82faf9ba80aea43829cb617660e3c14596113bd82b4882c2a94); /* line */ 
            coverage_0x020835f7(0xaabcf16387e2b0f6c18071630d4c9387a0e81fe29c0b1efe5e993109e9710081); /* statement */ 
return ProposalState.Executed;
        } else {coverage_0x020835f7(0x66c99420c068eb2121eada194d91539df7e511768223e91ee6809646fe93092d); /* statement */ 
coverage_0x020835f7(0xaad07c5bc859ec9670899fb69c4804dbc7d96c39fd2f37ddd0bd154ae4699829); /* branch */ 
if (block.timestamp >= add256(proposal.eta, timelock.gracePeriod())) {coverage_0x020835f7(0x14cd6feec61edce4bc98874bf44b313408dee5a4c7f91d7e4fd67470d697d97b); /* branch */ 

coverage_0x020835f7(0xde9b16752c7db8f8441e26fa6d0bacabc758a7f8aedaaee8ac0389b551dcefb9); /* line */ 
            coverage_0x020835f7(0xfa4f550b1882af3061a95911e4e690569cf1d9862cd2dad361dbc0d95b391720); /* statement */ 
return ProposalState.Expired;
        } else {coverage_0x020835f7(0x63a81c52bb88a6106e93a188747ea88f5abe59f1803d5c383c9d89ba084d2c45); /* branch */ 

coverage_0x020835f7(0x2cf048833510eabbb3da341f4ed50d260b1a3052a2f82c1c95ce4680a47d87d2); /* line */ 
            coverage_0x020835f7(0x51ff17edfca173fa0aa2c351c49831b78369d8d138049c3caa58d8d9b72f49ba); /* statement */ 
return ProposalState.Queued;
        }}}}}}}
    }

    function castVote(uint proposalId, bool support) public {coverage_0x020835f7(0xbeaa2cd8745ae6f30d67ee92332abc10a926cd0991435788394af5c8d866171a); /* function */ 

coverage_0x020835f7(0xa6c91619eec575853779e196211bcc8be712a9bfffff76499643577f088d21f9); /* line */ 
        coverage_0x020835f7(0xa427ffad75a62d06cec5a191392193b4b9fee6e2744bde53bef024667d61181d); /* statement */ 
return _castVote(msg.sender, proposalId, support);
    }

    function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {coverage_0x020835f7(0x0c4eea871ecbe978fadacfe6adedc2efa4c04aa4e67782d75c9f2bd3cdd1064f); /* function */ 

coverage_0x020835f7(0x5fe8e484df8e2030def36860e6df61232d420d02f01e5b19f49ab65dc970f43e); /* line */ 
        coverage_0x020835f7(0x0d3d51a90ba8e007c98a112218c5684ffaa66049702b6c3d54dfe52b186044cd); /* statement */ 
bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
coverage_0x020835f7(0xa231a092b34473ca2e46efd55cb55ce9b0477a38db92d4c6e5448acd6d60debb); /* line */ 
        coverage_0x020835f7(0xd7fed6bc04d0afc4088a0da5b639183b3da7e55f40bd242c3c5236be40b1ccd5); /* statement */ 
bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
coverage_0x020835f7(0xc62f3db0c229b316ffda6d85d6ebf2307090f6e4b3a4c4373d25de369ce0ac60); /* line */ 
        coverage_0x020835f7(0x0efb0d30af80b5f62b97564b9e24554d5b14fc7baede21d519f0d69e00f62d9f); /* statement */ 
bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
coverage_0x020835f7(0x09b87383b86e1da7669c87b1d28dbf26453d7c3da33cf39ad4bceb85045a6556); /* line */ 
        coverage_0x020835f7(0x970043105fb3234e5b839092cb321471895b80ca03c372978de959c2b06f65fc); /* statement */ 
address signatory = ecrecover(digest, v, r, s);
coverage_0x020835f7(0x996c720f15fded25683599cb33f15fde1dc61e56d2456fe781271e49c2b3f8eb); /* line */ 
        coverage_0x020835f7(0xb74345f3ce84d25453c4d7fc6520f708c22e297625377293e5e584b23d20948c); /* assertPre */ 
coverage_0x020835f7(0x4ce108572a8c50b1fc52520d1cb2fa42f462d2bcb775cdb0bcc0795769a050ce); /* statement */ 
require(signatory != address(0), "Governor::castVoteBySig: invalid signature");coverage_0x020835f7(0x32c3c97f61c3b9aed9bbc1ca9c4d91d786a5348df61b8570ce0d66f9ad3e605e); /* assertPost */ 

coverage_0x020835f7(0x9c9412416f6c8f237d94ada20bbf35ea066e51dedc2ba8e592c7af8523ae23fa); /* line */ 
        coverage_0x020835f7(0xdff9d27e49d9e428b1bc25883d61ade9c0a8f0544d92bbbaba3cff1043cfb21f); /* statement */ 
return _castVote(signatory, proposalId, support);
    }

    function _castVote(address voter, uint proposalId, bool support) internal {coverage_0x020835f7(0x2884df06db85dc5fdb88533cab98b516a75531df9f85e941823d875358684523); /* function */ 

coverage_0x020835f7(0xd0a57510c926634e2500bc2444d9e2bf171aec1b1effc634cc62e8f32ec063a2); /* line */ 
        coverage_0x020835f7(0xab1c5be257542d46eae2085c5995d4bbd533c414ed63d770a7dab9c397f3f202); /* assertPre */ 
coverage_0x020835f7(0xba286f6c095b41a04a8a2eb4d6fde429b0804a7d97670242bbbd01b25bc4d7b3); /* statement */ 
require(state(proposalId) == ProposalState.Active, "Governor::_castVote: voting is closed");coverage_0x020835f7(0xceb698a95be0c50efe0874dc6e24fa245bb03e0394827c816f27959ea3d78765); /* assertPost */ 

coverage_0x020835f7(0x9517bf48fca9e0651204b0650a4c3293e7eaa26594a5037b92c9cdec11567e06); /* line */ 
        coverage_0x020835f7(0x647e2a52d6e3d1637b8b234199d92aafdbc734f8aef8ac89e773cdf5a63f7efa); /* statement */ 
Proposal storage proposal = proposals[proposalId];
coverage_0x020835f7(0x79bc7474352b66cbbba539624bdd2abb1c01a5d21f874a607e0d3862d0fd6dd3); /* line */ 
        coverage_0x020835f7(0x1859249204c8496b9601fcb014f0e0afd6a467284d078fa8e044e377158c45d2); /* statement */ 
Receipt storage receipt = proposal.receipts[voter];
coverage_0x020835f7(0xcb76282da51a0e83061abf497e4636a390a66c0a5ee7d2e886e5f17981ba0222); /* line */ 
        coverage_0x020835f7(0xcc8a7048c8211c371487189358358fa3038b56375f2ba22bcc2f1276faf371aa); /* assertPre */ 
coverage_0x020835f7(0x891b2a93cd1244870fe2aeb8ced6dea0dbdbe88f590b68ff0493144039ebebef); /* statement */ 
require(receipt.hasVoted == false, "Governor::_castVote: voter already voted");coverage_0x020835f7(0x33e54564ac326716ec73fa9ca9573613ab1a2395d76a27a4ab4cbf48964052d2); /* assertPost */ 

coverage_0x020835f7(0x3a73afd7ffd8fdd863d34ea4276775a68be037c41e517460bc1a134f949fda50); /* line */ 
        coverage_0x020835f7(0x7e878d4ddb3ebc4b73bad7cddb159b2aaa7fb89c65942ed83f332b4b08b564b0); /* statement */ 
uint96 votes = sync.getPriorVotes(voter, proposal.startBlock);

coverage_0x020835f7(0xd802590b32367497c7200bcfa3144041909512b5ffceb2c2f5d7e56ecd5159c2); /* line */ 
        coverage_0x020835f7(0xea31f5cdb13c45203d1f2c828de775fff2074987a4713a8c55aca3cdf1b2f858); /* statement */ 
if (support) {coverage_0x020835f7(0xe91b691962a346dbdfe58989a3e8db9c6b0da70bceebcc781704a25d674f0d70); /* branch */ 

coverage_0x020835f7(0xa82ab86aca100ffc3eceecc327db92ce410e43bbe414f4bcf095362c7cc31ef8); /* line */ 
            coverage_0x020835f7(0x36c2f32c3c4e0bf1b290446a03f5f36bce441e68158784fdc3a77e466863106e); /* statement */ 
proposal.forVotes = add256(proposal.forVotes, votes);
        } else {coverage_0x020835f7(0x3e393fd40abc4c71adf06098fec28496b8be2a69d546b53be5abe12da4752aaa); /* branch */ 

coverage_0x020835f7(0xefd069dba18719dbd80a54e3406b20bda76b120939b97c6e83ed1645f0b124b5); /* line */ 
            coverage_0x020835f7(0x5c885b1698b545e9842d48250d776238430bbda7c226214f077a7452f087d774); /* statement */ 
proposal.againstVotes = add256(proposal.againstVotes, votes);
        }

coverage_0x020835f7(0x818727f42c71ed3e2a8b400af1656217758a7cccee90dd7076f0597a813cdd69); /* line */ 
        coverage_0x020835f7(0x4af6fe32ab9a17842034955dad3da95240f7b4538ab2cb0ba01bbd2175bd1e18); /* statement */ 
receipt.hasVoted = true;
coverage_0x020835f7(0x716edcafe9da7ad9f88a5371f352d9987ece1915b6f10cbe7131ebca5dd7be15); /* line */ 
        coverage_0x020835f7(0x1119fa51575c2aecb3e33ca2d56b17fd755272816d3941e3efbe422fbfbe25fc); /* statement */ 
receipt.support = support;
coverage_0x020835f7(0x6e1a5eaa0728ed42eb44f88e296dc6974b001ee34ed38bdaa6456abe4c32303b); /* line */ 
        coverage_0x020835f7(0x6cdba5546ba0f2de89b5d41d4a32d6492be72f42357a195aea484d7903edc19d); /* statement */ 
receipt.votes = votes;

coverage_0x020835f7(0xc1765e87d8d7a81456e601a26b8bf611a6c197eca5e1996c16ed142046efb728); /* line */ 
        coverage_0x020835f7(0x360c30347aea5baefeede972dfcdf7fb5513a99773e654c5a37580d20bf832ca); /* statement */ 
emit VoteCast(voter, proposalId, support, votes);
    }

    function __acceptAdmin() public {coverage_0x020835f7(0x8e5a4ba3f37c6cc9ac9534126e28bbfec0b3707700baf57308548fa28a3b2ba8); /* function */ 

coverage_0x020835f7(0x29173cc55dc5e3cf28539b2e0905420cb64e7e3eb8c5ac97390c8fdc4e01d33d); /* line */ 
        coverage_0x020835f7(0xab96ea44d21c295ae726b72c6ea0da3f3b77da95b3322b92fe904f496f2a4ba0); /* assertPre */ 
coverage_0x020835f7(0x43e60c81c87a1cdef614a8f237beaa394693d0f0fd2c39ce7f36649d97638945); /* statement */ 
require(msg.sender == guardian, "Governor::__acceptAdmin: sender must be gov guardian");coverage_0x020835f7(0xe4cd490e566a3b60d5ebabcd2e307e2e0266b7b8663968a16a070b3dd2072308); /* assertPost */ 

coverage_0x020835f7(0x2a7e211431ddba3b7a4347a1d8da042e34ac28718422f69b736665b25f029586); /* line */ 
        coverage_0x020835f7(0x5d027e5e455958c0be3a598dd59009cb3f51f3871c676b8d646988fbe0ba8b7d); /* statement */ 
timelock.acceptAdmin();
    }

    function __abdicate() public {coverage_0x020835f7(0x1ef56320cb7e904797b8356547509afbdb0f724121e774741d83741eeed08c43); /* function */ 

coverage_0x020835f7(0x485c52c1019ab9977636f7f97cd7e5f05b9909da0e691d10091e76ffc51cbc9d); /* line */ 
        coverage_0x020835f7(0x15d4b99b59f651313e39742d417c1d9ae2d411651d7df6421e695ea20d66b44d); /* assertPre */ 
coverage_0x020835f7(0x25f1ea7a2362272cbdf0085c1e6fea035614ab75b4d894a3ca73c7bfe652df58); /* statement */ 
require(msg.sender == guardian, "Governor::__abdicate: sender must be gov guardian");coverage_0x020835f7(0x818bc12125927e0c458a863e603009243d9f9281f334a9c0ae8f1e220c1d2c2b); /* assertPost */ 

coverage_0x020835f7(0xd1c792af600a92ce7f2770105fc7ecf89ec8ebd7909c981ee4c1ee6fb838d839); /* line */ 
        coverage_0x020835f7(0xc25387e61568cede0697359a030bc93c60a6c34626f26fa215800218f046216f); /* statement */ 
guardian = address(0);
    }

    function __moveGuardianship(address _guardian) public {coverage_0x020835f7(0xb12b2263a654735d037f99473af8abe1eb50b25f2fbe7bcfe01e464e804205e3); /* function */ 

coverage_0x020835f7(0xfc64ab61609cc39d26304334b1918e4e94815b6512667fe1ca0c55e1e552db21); /* line */ 
        coverage_0x020835f7(0x83eb5b94a467a6bd7aea926ba06155e65fa54805c749919d9d4019ebb3239b15); /* assertPre */ 
coverage_0x020835f7(0xae5b0bf95f0684f8d3dbac96b0b281072b103cb93b8dc7cb9bf4c6f135c7efe2); /* statement */ 
require(msg.sender == guardian, "Governor::__moveGuardianship: sender must be gov guardian");coverage_0x020835f7(0xfba1eebe8229392289a878745f0b9b3dc04bbf78494042257e24aa65b8e099d4); /* assertPost */ 

coverage_0x020835f7(0x8e08fbcafd2ee71a93b969e3880ad3c4a299db97ee3efdf63eb23c0d98812137); /* line */ 
        coverage_0x020835f7(0x9c4aed8a82f0c28ba887d965d414bec9c393c4d4fc18c8359afd30bdfec30e3d); /* assertPre */ 
coverage_0x020835f7(0xd22c99207ce5509fb09561af7f2e8e83241edb94fb07947be011f6c896f4f6b4); /* statement */ 
require(_guardian != address(0), "Governor::__moveGuardianship: new guardian cannot be address zero");coverage_0x020835f7(0xef698b815b505bff3d0e4357003eb8459e0a9e65cd8b515cf849bca1bf6fe6db); /* assertPost */ 

coverage_0x020835f7(0x5994195206b4f6d221c1e2dfea39508822df81516e1e09fc80837bb5e9f9e2de); /* line */ 
        coverage_0x020835f7(0x1dfeea14e2dab2aedaf22c60979e49b8a269ff1c6e584905ea8888b24d1ccd49); /* statement */ 
guardian = _guardian;
    }

    function add256(uint256 a, uint256 b) internal pure returns (uint) {coverage_0x020835f7(0x0d837d4656c812167fe1f32f39ced9061e7d53a14432a53c507afbc89fbb1563); /* function */ 

coverage_0x020835f7(0x51b6580adb6d866f63b97631fc34beb15d5ed3092c1ef8db218bc67da46645ed); /* line */ 
        coverage_0x020835f7(0x894f9f4b424c8193f0d1e81c6a2d7f97ad4a0d87427f88d0fabdb584bedeea48); /* statement */ 
uint c = a + b;
coverage_0x020835f7(0x13f1a90fb59477e301780fe47aa8ae19a8b91a9cac424dc073d5643153f0c78a); /* line */ 
        coverage_0x020835f7(0x95f31ce880bd6e3289dda4abb7145c3e35dfeddf0de2b353eb6877ef8f5b17f8); /* assertPre */ 
coverage_0x020835f7(0xb86434a35d6d20e289be72029e9f0bd10cf95773f421921f2c193141406e478b); /* statement */ 
require(c >= a, "addition overflow");coverage_0x020835f7(0xb921ffe2b0776f3b0b897ed99654485659acd104d1581e6bf94a208c296dbcb5); /* assertPost */ 

coverage_0x020835f7(0x58ee50035fe329fcc133f6bd1eb10750fc8dd62fa66a042d466f0308a9f97341); /* line */ 
        coverage_0x020835f7(0x8cbdf6be1366823718bc8a957632a08eaec2e05997acdce5915335920bfa9ef2); /* statement */ 
return c;
    }

    function sub256(uint256 a, uint256 b) internal pure returns (uint) {coverage_0x020835f7(0xda142253acaf48cb1ed0b238f0ec0fbd5741059c86979e2747d2cf4cbc8d5c4d); /* function */ 

coverage_0x020835f7(0x51ad5b7f966e9f85cfdd16c851c1ebf7eedcd0fab5df728d3c5517151ce64b2d); /* line */ 
        coverage_0x020835f7(0x6063602284450af687fbcae0d740bdf1b19309b1e87cbda848a1f68733235a45); /* assertPre */ 
coverage_0x020835f7(0x61a6ee9be71124f2d0cda9b56b1aae337a09b250f291bac3279d0f70fba99f45); /* statement */ 
require(b <= a, "subtraction underflow");coverage_0x020835f7(0x4f22c36d8b12fc8f5bbd685354a571f9ffa9e8adff77c54c3d657b36ffae2361); /* assertPost */ 

coverage_0x020835f7(0x8ee0d1a675cc7cccc79d3e50448d040d36b4fe865151c206297faf7ce152aafc); /* line */ 
        coverage_0x020835f7(0xd33b9569dff32ce3cd9367e9be9c68c38000992d4853c2ddad31dfbf454f4c74); /* statement */ 
return a - b;
    }

    function getChainId() internal pure returns (uint) {coverage_0x020835f7(0x69cc5d4562d6b6bb0a27a4b173d34427aa42f69f8b7e4a35fb0bcfc478f5841c); /* function */ 

coverage_0x020835f7(0xdbcb0241244f60d788fb06373b0ed4c2bc08e97b6608c24c80b1e81ee177e3b8); /* line */ 
        coverage_0x020835f7(0xf3cf85f3bc191f139d75488274d3ffcc60b5fa12ae430cd002fae9ed58c64cc3); /* statement */ 
uint chainId;
coverage_0x020835f7(0xb6ce2e8e532b48237cbe1952449d7e4d7aebf60ddacaf984e482c9bfe42fe7a5); /* line */ 
        assembly { chainId := chainid() }
coverage_0x020835f7(0x4672b9f8216aee360d87c8ff4ff6b70d23989d274dd4086165fdba75d7cf0e19); /* line */ 
        coverage_0x020835f7(0x0c0ead0fd5519935fe7a901110cf1eaf6bf28e13ea50af3122bd3d12ad4e0b4c); /* statement */ 
return chainId;
    }
}

interface TimelockInterface {
    function delay() external view returns (uint);
    function gracePeriod() external view returns (uint);
    function acceptAdmin() external;
    function queuedTransactions(bytes32 hash) external view returns (bool);
    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
    function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
    function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
}

interface SyncTokenInterface {
    function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
}