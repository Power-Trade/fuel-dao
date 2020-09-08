pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

// Copyright 2020 Compound Labs, Inc.
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

contract SyncToken {
function coverage_0xf7283160(bytes32 c__0xf7283160) public pure {}

    /// @notice EIP-20 token name for this token
    string public constant name = "Sync DAO Governance Token";

    /// @notice EIP-20 token symbol for this token
    string public constant symbol = "SDG";

    /// @notice EIP-20 token decimals for this token
    uint8 public constant decimals = 18;

    /// @notice Total number of tokens in circulation
    uint public totalSupply;

    /// @notice Minter address
    address public minter;

    /// @notice Allowance amounts on behalf of others
    mapping (address => mapping (address => uint96)) internal allowances;

    /// @notice Official record of token balances for each account
    mapping (address => uint96) internal balances;

    /// @notice A record of each accounts delegate
    mapping (address => address) public delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint96 votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

    /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    /// @notice The standard EIP-20 transfer event
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @notice The standard EIP-20 approval event
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /// @notice An event thats emitted when the minter is changed
    event NewMinter(address minter);

    modifier onlyMinter {coverage_0xf7283160(0x7cc9391e18b0e43bf8e1513eb1a9a8b554d40eb1a0c9ee7fd6072b45f2816818); /* function */ 

coverage_0xf7283160(0xbb48f945bcff8200c4859e141cad9ba71c56b60c27be2ee881e47d3c1900015d); /* line */ 
        coverage_0xf7283160(0x7cdedf0b9d068201994b3e0308dadf7c2849f0219ed89e902226bfe102a10d04); /* assertPre */ 
coverage_0xf7283160(0x3e4feb72b303d942016b725368f6fc03f460cef3c21de3d48ee258b3b895e9b2); /* statement */ 
require(msg.sender == minter, "SyncToken:onlyMinter: should only be called by minter");coverage_0xf7283160(0x461ce6780e27b7471f5db92e5355e3985a7a531ae1ae0dbe5a27957b951689d9); /* assertPost */ 

coverage_0xf7283160(0x5fbd8d6c3c810918d9cfab37c031d65398453241640a3116c375d43b87730727); /* line */ 
        _;
    }

    /**
     * @notice Construct a new Sync token
     * @param initialSupply The initial supply minted at deployment
     * @param account The initial account to grant all the tokens
     */
    constructor(uint initialSupply, address account, address _minter) public {coverage_0xf7283160(0x49aaf75a8764ff19d1dc00740d208479e717b9ba8f0ee76e9b5a3625616b0452); /* function */ 

coverage_0xf7283160(0x22a41ea07014332f1db48827abe92ff1ac264fb867efb39b1e74072acf832101); /* line */ 
        coverage_0xf7283160(0xd16ef6c0d97e6dadef54dfb96002c67f63a7c4385d5354c7943eea2fd92cca74); /* statement */ 
totalSupply = safe96(initialSupply, "SyncToken::constructor:amount exceeds 96 bits");
coverage_0xf7283160(0xaf182de8156f91e68715a72d1094751cbce7b8c2c0a4570dad70321b7f298537); /* line */ 
        coverage_0xf7283160(0x8f12bac4b3d83c52ee8064503aa3fa4ebd8c43710e7c6b892e0bf391811eb37a); /* statement */ 
balances[account] = uint96(initialSupply);
coverage_0xf7283160(0x74c05ef69323ae742530b2710eddd7ec1c48b64321c13018be6f840817b08a98); /* line */ 
        coverage_0xf7283160(0x53858df12798f8cf35caf67025572276117a893c69a0915df461a09021ea2963); /* statement */ 
minter = _minter;
coverage_0xf7283160(0x433da25eb3b056222f355637d9a692bb7c6482b1b4b0037f2be11eed716ca6b8); /* line */ 
        coverage_0xf7283160(0x75cc8f614defe5cfb121402b71bb5cc6bcb4f840b908b0a827d20c494408ce0f); /* statement */ 
emit Transfer(address(0), account, initialSupply);
    }

    /**
     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
     * @param account The address of the account holding the funds
     * @param spender The address of the account spending the funds
     * @return The number of tokens approved
     */
    function allowance(address account, address spender) external view returns (uint) {coverage_0xf7283160(0xfaa278e95a65a7bfe33a157381dc3ddde8d3bfd92fd028e0f36dec8ddbee66f7); /* function */ 

coverage_0xf7283160(0x24933f2c901a789f92a379cb0a19e77270efa10573e330c64047ce8a409ebceb); /* line */ 
        coverage_0xf7283160(0xbd3e467d2d135c7668ab07fb060941acb14f4cad4437b5d4f25d992ab72a8d27); /* statement */ 
return allowances[account][spender];
    }

    /**
     * @notice Approve `spender` to transfer up to `amount` from `src`
     * @dev This will overwrite the approval amount for `spender`
     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
     * @param spender The address of the account which may transfer tokens
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @return Whether or not the approval succeeded
     */
    function approve(address spender, uint rawAmount) external returns (bool) {coverage_0xf7283160(0xa85dfb7b3303cc575bd319144eedbcb8e0e21a1dbc38f9f0a7ad14d636a6fad2); /* function */ 

coverage_0xf7283160(0xd14d264f8213f1fc89b594ce29f83f7c8ffafb378297334d17464519c85729b1); /* line */ 
        coverage_0xf7283160(0x988b4a24cbf04784cba469b358858f09b47e0df4984a0740cddfa91761fc11cf); /* statement */ 
uint96 amount;
coverage_0xf7283160(0x1faa446e48fc7aa3df5aded3a2b00647ed46b4a371af6093fa87886d8b11cca7); /* line */ 
        coverage_0xf7283160(0x111f34b8fdb1d0aeab5968041e098f44389ec2805af429ca71bc6a26c5666d37); /* statement */ 
if (rawAmount == uint(-1)) {coverage_0xf7283160(0x756ab9ad4044072eaa3d46a9fd176594246d2e9b22f67defb0c4b3924c890507); /* branch */ 

coverage_0xf7283160(0x8e6fec03450caaf931448cfdd23ca1a667e2b73042d823b813f3c0d25d977c2c); /* line */ 
            coverage_0xf7283160(0x6801c34b4e7838434503a96e81058cdfa5821f1c004b3fcc1feb828cc5998652); /* statement */ 
amount = uint96(-1);
        } else {coverage_0xf7283160(0x0e60f16a7ed79039cdd620994c346bd95e30f4706d02ca3f0b18c518ff18bf51); /* branch */ 

coverage_0xf7283160(0x2d51bd260972b57b9243ce63f5e56a617ff9b576444bab4c7e2d4ff24a6a5f28); /* line */ 
            coverage_0xf7283160(0x071b79ac37b7a598aab946097db36ddf946ffb33e87c76ab791c580eb7f9ec50); /* statement */ 
amount = safe96(rawAmount, "SyncToken::approve: amount exceeds 96 bits");
        }

coverage_0xf7283160(0xf28d56c46ba71d9bdf9e6f0ee443a62ec88a796a51fa5807dceb20161f2cf5ad); /* line */ 
        coverage_0xf7283160(0x54b07106643adf75aa8e9f8b6843b14ff215ad270a5e3ea4943d8c5915938c60); /* statement */ 
allowances[msg.sender][spender] = amount;

coverage_0xf7283160(0xf12142c16bc5a12673c5ff1788c154b15632c87138254f9b4749b231b4a651aa); /* line */ 
        coverage_0xf7283160(0xa38f2712b5bf0e217f8f661c15377e10129245c07adb4f6d6c24fea5e2f64940); /* statement */ 
emit Approval(msg.sender, spender, amount);
coverage_0xf7283160(0x0d2cb9c89f19836f1fee6be00acf8684a05bc6997e29eff7d0b4a8c4ed0a435e); /* line */ 
        coverage_0xf7283160(0x8ca81bba27c9a574c8b38cc75983ef5863b51d0549d1d9a16eb3cd38437a95c4); /* statement */ 
return true;
    }

    /**
     * @notice Get the number of tokens held by the `account`
     * @param account The address of the account to get the balance of
     * @return The number of tokens held
     */
    function balanceOf(address account) external view returns (uint) {coverage_0xf7283160(0x5cc5b1c9c8295078c29a3bed33a152fa86eb421b29015da5afcd4cd92b98fcb4); /* function */ 

coverage_0xf7283160(0x01663589408d6fb71a6ceba64a259cde5f9c0ef550ef4611a8ee772d140d6c71); /* line */ 
        coverage_0xf7283160(0xee5b5ff1369f9924ba22d6a5bfc6bbda6ae491d3440526b2951835412c3ef26b); /* statement */ 
return balances[account];
    }

    /**
     * @notice Mint `amount` tokens to `dst`
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to mint
     * @notice only callable by minter
     */
    function mint(address dst, uint rawAmount) external onlyMinter {coverage_0xf7283160(0xa779bef45efbe1cff97b2d57b022c9acf09fc61147e5d13655a409dddf41da56); /* function */ 

coverage_0xf7283160(0xdd6c4fcb8f95ddf6afd2f5e1517dc93a314e1c81f552654b71c4055652b2db47); /* line */ 
        coverage_0xf7283160(0x44047da353e969923633d8b7c3efd989c942906671a6aeaaccd5245322ee242b); /* statement */ 
uint96 amount = safe96(rawAmount, "SyncToken::mint: amount exceeds 96 bits");
coverage_0xf7283160(0xa2cc95d52ec4d316970340064d876e84acf3cf8cb1208c6346f7e3bbc8e56195); /* line */ 
        coverage_0xf7283160(0xc9d4e67b7867ec55131920fe54b0a042807570500ff62ccb4e317756be9c233c); /* statement */ 
_mintTokens(dst, amount);
    }

    /**
     * @notice Burn `amount` tokens
     * @param rawAmount The number of tokens to burn
     */
    function burn(uint rawAmount) external {coverage_0xf7283160(0xaa8aee7a12962b3288c3d10163fc7bfb1741a64f1865639bc49bdfb59ac686ea); /* function */ 

coverage_0xf7283160(0xf5b36139017b3069cc1d8f412a6a4cba4eb30277744a090296aeeddd602fe0c3); /* line */ 
        coverage_0xf7283160(0xbc956622a991a8ab76a95fca76bc746160bccd0dd201a6e2635c20012a597b7f); /* statement */ 
uint96 amount = safe96(rawAmount, "SyncToken::burn: amount exceeds 96 bits");
coverage_0xf7283160(0x3c4b0589a4ecdd5687b92a6c175bf6fa56f045def4efd90bc42fa6a69fff40ef); /* line */ 
        coverage_0xf7283160(0x8afa4424a8a39c8f5e9b665c4f8aae05399752b52db88dc2274735fe72515d19); /* statement */ 
_burnTokens(msg.sender, amount);
    }

    /**
     * @notice Change minter address to `account`
     * @param account The address of the new minter
     * @notice only callable by minter
     */
    function changeMinter(address account) external onlyMinter {coverage_0xf7283160(0x5a82d5dca60cd6ef2f7fd6c15ed6211ec581f2fadcf400144c64bbd0e07f7dcf); /* function */ 

coverage_0xf7283160(0xbb7d1024fb0d7ead1f047d30b0d15f98a2c41143ad7edd1c860c98d7441f4eea); /* line */ 
        coverage_0xf7283160(0x22a0bb8c646a6c87765ec46a6c21a497a1c5b27d51af2f0ae610ed07798213e8); /* statement */ 
minter = account;
coverage_0xf7283160(0xb46b83666e5e6c3ac162e6ff3a6496caddca5bbdf11f0ea7db1a2a41ea7dc9ea); /* line */ 
        coverage_0xf7283160(0xb0d7f1d161d95308cc24989d03af24049045838db28ddc49ea8eb7d2cbe2d366); /* statement */ 
emit NewMinter(account);
    }

    /**
     * @notice Transfer `amount` tokens from `msg.sender` to `dst`
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint rawAmount) external returns (bool) {coverage_0xf7283160(0x91b61afd4428334c633ad813baf709349069f19a0c4d2344f28d04a56774b3f2); /* function */ 

coverage_0xf7283160(0xc060a11ab9d34a114f67f2225ced9e9e2f4103b6edddc0b323fa2dc3ed0aac08); /* line */ 
        coverage_0xf7283160(0xb8e2c55410298dcb7c5b9805f7f63d4375d0d7b1b3df99a8e004e21510bb5419); /* statement */ 
uint96 amount = safe96(rawAmount, "SyncToken::transfer: amount exceeds 96 bits");
coverage_0xf7283160(0xc7a03609b1820e45767da1190cd65cc06a1d5e9f26e23169b30f905ca9c11b9f); /* line */ 
        coverage_0xf7283160(0xc0fb4922e637e4c8ec5070499d8102a7ec6d9889b82223e83257b474961d91c9); /* statement */ 
_transferTokens(msg.sender, dst, amount);
coverage_0xf7283160(0xe2884a25b7804ce4484733fbc0f09760e52beea00f8b2e0315e88f0a67eec769); /* line */ 
        coverage_0xf7283160(0xecb4a00299e98ce70cbcaa7439c2f81d36dfdc25ab252fa7892e0261491c6768); /* statement */ 
return true;
    }

    /**
     * @notice Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {coverage_0xf7283160(0x4784db81bce2530e3465043a290cc295c6f63842bf2db78093816e21066aef02); /* function */ 

coverage_0xf7283160(0xbda0efba4c020ec73a828dbbc4b44250ec86ba9be17a7fcdefb959c1bda6f6ba); /* line */ 
        coverage_0xf7283160(0x97a18ed47a70b256db600487b4579fca790ea97b9babe03dac574581fc5e7b94); /* statement */ 
address spender = msg.sender;
coverage_0xf7283160(0xe4dfd2998dc021d7c0dfb5eeaf0ec024a2bf839f5606299a32ac1649d563ee46); /* line */ 
        coverage_0xf7283160(0x080f9103ccd55f080497758e848b7b0a85d99ad239afe97465a215b7e867b5af); /* statement */ 
uint96 spenderAllowance = allowances[src][spender];
coverage_0xf7283160(0xa9258f2757f91a803eeff8b9941a4c4baf4d1dae681f9fee96a5045a525bc157); /* line */ 
        coverage_0xf7283160(0x940dab7933a522429f92e91ee3838cee1521ff83b95d4953467443b436c5e18c); /* statement */ 
uint96 amount = safe96(rawAmount, "SyncToken::approve: amount exceeds 96 bits");

coverage_0xf7283160(0x4a62edfda1641112983bc17a149a9a3a19bd4d12d542795b305dd7581534ba01); /* line */ 
        coverage_0xf7283160(0xb5f24e14140a41d0baf2a87db41e2ddf9caa091d1c1b34638a08c665d5bf70c2); /* statement */ 
if (spender != src && spenderAllowance != uint96(-1)) {coverage_0xf7283160(0xc16fe29463a5a4adbc37a40a5ad41a28bdc95dda03c37ced556f03d1209523d3); /* branch */ 

coverage_0xf7283160(0xbfb3627635f1585591f6e18f80f4a838014382889b418a598c9387a46ae82bef); /* line */ 
            coverage_0xf7283160(0xfab0557a2ede309950e11bb58d366abd970311244ff3232614ca1e90d986979d); /* statement */ 
uint96 newAllowance = sub96(spenderAllowance, amount, "SyncToken::transferFrom: transfer amount exceeds spender allowance");
coverage_0xf7283160(0x82936ed9e19314c3c5a2ca75fe5beb30ef1e4dff863caf672b63e65e8da5cfe6); /* line */ 
            coverage_0xf7283160(0xccb4f3ac1a7b172533e26976907312194788679e447e4d747d7e5ecf59afde36); /* statement */ 
allowances[src][spender] = newAllowance;

coverage_0xf7283160(0x498b2f9746e93ea75e1efe8c61f655d1d61d6b14c1e677aa41e6e84fbfaa59fa); /* line */ 
            coverage_0xf7283160(0xab12f2a329deab3cb724c3943a6a15ef6367f1039d7a32b454dc314a39e3e0ec); /* statement */ 
emit Approval(src, spender, newAllowance);
        }else { coverage_0xf7283160(0x3988915a940acffc4d6ec3d7e7695ed528c0ffb5c6c2fee25175969b68246732); /* branch */ 
}

coverage_0xf7283160(0x4d83bb039c39d569a5b0a70c7d91f9fc3af05a5f4003c0d16e9686f0d943dc0a); /* line */ 
        coverage_0xf7283160(0xb4c6790a311ed40b9837301ee9e8cc42645e817262985e2e6049cee1394ccd6c); /* statement */ 
_transferTokens(src, dst, amount);
coverage_0xf7283160(0x31f7bf7d7c283801936f9ff669ca7eb9ce8650087d0756ef895c27297358f515); /* line */ 
        coverage_0xf7283160(0xaa0772a96fc910764d6e17dac81b10836736f5f8b1aada50e3f801f2c5522806); /* statement */ 
return true;
    }

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegatee The address to delegate votes to
     */
    function delegate(address delegatee) public {coverage_0xf7283160(0x83f13a5bf72624448ef4fc0a2b1f8c0f5a25bab34600d17653d7feecd01cbb65); /* function */ 

coverage_0xf7283160(0x922ef5635886305974e377566f49173b6953936550b5aeb781c21aefe5b35770); /* line */ 
        coverage_0xf7283160(0x60d7b67a66e5e0c0a832c384e1519ed606ab4a343f87312e05de0a7e8d860e5e); /* statement */ 
return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {coverage_0xf7283160(0x0f9bffb9bfd9baac1f9de28d2abe8962713196d44fe1d8ef467c571fd0249cbb); /* function */ 

coverage_0xf7283160(0xd82b1e054368de0f3e3bce80123c1b33306f394eea2e6bef23b37820142d3a33); /* line */ 
        coverage_0xf7283160(0xfc3489509d750c9fdc6d4415479807bc329653c4a2f6c9ad2eec16009d590a55); /* statement */ 
bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
coverage_0xf7283160(0x7b549078f2aa2145660babfa1b8f51aeb2752efed9f4dcf37ad2a5223c529d8e); /* line */ 
        coverage_0xf7283160(0xb7f21ca08a6edfbcac6d1c1ba4e1d46655e6a0bd88fe8ec3f7b84df670bb8981); /* statement */ 
bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
coverage_0xf7283160(0x4840bb386de5e0643e2ea414e54ae956cbebabc23613ed00e53aea13e6162e04); /* line */ 
        coverage_0xf7283160(0x377d385c2b4707bf108a71875ca5e4bb1dbe8cafd709954fe7388ea776991584); /* statement */ 
bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
coverage_0xf7283160(0x1893e43128b7e45ab6d5aba8b02abad49d35cfff01b97c57fafd2676e79291a4); /* line */ 
        coverage_0xf7283160(0x60911f926a50712b2ae1f30a3073dbe3cc34e1c6c438ddfb7f0e83b8350c5f7b); /* statement */ 
address signatory = ecrecover(digest, v, r, s);
coverage_0xf7283160(0x98ce1724942ef3fdd3a1210a2f5c5f4e27493b2ee503d5b807121c765395d992); /* line */ 
        coverage_0xf7283160(0x4617885776a0655e3679fb3115839a0dfa0612761d069e827066619b9db8f2a0); /* assertPre */ 
coverage_0xf7283160(0xf7885e84e9a68b82c57a5c1d9ce310c5449c9fb03ac9b3f1551bb1cbee9eec02); /* statement */ 
require(signatory != address(0), "SyncToken::delegateBySig: invalid signature");coverage_0xf7283160(0x94eb401371c34f2c76a9e4d4390d30b88c42b9ec801e43b2ac82ba62e31f303c); /* assertPost */ 

coverage_0xf7283160(0x48f1acf29bd05abbca83a3b308c75c787423064a20c7503e992174c4e0d8e69f); /* line */ 
        coverage_0xf7283160(0x8bb97d5049d09eea0eac5308f66fcd7423f585eeff10292cc74a4825892debe0); /* assertPre */ 
coverage_0xf7283160(0xe6616817ab9a8a03aaa0715adb2aaa5c6728907a5703e7c9b396fc829aafcb42); /* statement */ 
require(nonce == nonces[signatory]++, "SyncToken::delegateBySig: invalid nonce");coverage_0xf7283160(0x82928753c4e28468dbe1222cf2e9b38250f62ab4e1bad78783b3d7cd6b1e6eaf); /* assertPost */ 

coverage_0xf7283160(0x930a009952b43e464588570c608a5f65f81b706e4807a8d9b433ed0479dd2f16); /* line */ 
        coverage_0xf7283160(0xd5c642f96de1c1663a779f4d462532b228e0bd45832a1c24ddc567ac9e7e4f48); /* assertPre */ 
coverage_0xf7283160(0xd7b727cb6ec3360afb887a5113a4b545308b84504f1a88b7fa7e2083b2000352); /* statement */ 
require(now <= expiry, "SyncToken::delegateBySig: signature expired");coverage_0xf7283160(0x0db24a8d88573f6774556fabc4738ce703fc09545cc7cc1dc63362c46bdf4c60); /* assertPost */ 

coverage_0xf7283160(0xf684ec3e3796e642b8afe4d0dd7cc1c152f220d6438bb9923fab3942e9539ff3); /* line */ 
        coverage_0xf7283160(0xc6a0c0737f2416fc7d3f9b1d13b74f724d69c1850e3457b6a795f244275d6f96); /* statement */ 
return _delegate(signatory, delegatee);
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account) external view returns (uint96) {coverage_0xf7283160(0x58d440f7f703ea33edc5d62d6f7340aa5b3299e0a48717cc1633922fa983115a); /* function */ 

coverage_0xf7283160(0xf37287cc43859fdedffa5d4e1cfde18bf7a831049154af14340d4e88da0ede23); /* line */ 
        coverage_0xf7283160(0x94e8fdcd22ca64000d54fb5ee04ee9365eefc07c60720ad9abe2bda0ce9f73d2); /* statement */ 
uint32 nCheckpoints = numCheckpoints[account];
coverage_0xf7283160(0xcd29563aff136df96fa91f0ade5cfa9f3528f0682649c4ee973e7ef45d604013); /* line */ 
        coverage_0xf7283160(0x0758aa235eb561cdbef3f54d4502c60d5c0198f2203a683d585348adfbeb217f); /* statement */ 
return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {coverage_0xf7283160(0xda032f96318caa5c01b7f2628b3b1de5a47b1b963f3151f9fae14a2a4cb2cbca); /* function */ 

coverage_0xf7283160(0x132517b0a79cdda42ccfa98a863a5805a04f3de5aadafce712aabcdfadcf48c8); /* line */ 
        coverage_0xf7283160(0x85b7d5ca3b567f7c916622f86dfb66bdc5f49e24d604ec84e0786b3a10e5d8f8); /* assertPre */ 
coverage_0xf7283160(0x35ed17900b3cd60c11b4e0b0754bd61f78c9144d6158187f08f1745a6e69d815); /* statement */ 
require(blockNumber < block.number, "SyncToken::getPriorVotes: not yet determined");coverage_0xf7283160(0x57da432845e8a2d950af2d33f9d630152b747d400092a0d4ceb80a4ab9d0cc0c); /* assertPost */ 


coverage_0xf7283160(0xf2b4273d660f1e866a73dc88907e2f2fc08982b29dabcdcaae87b07ff4a1ba20); /* line */ 
        coverage_0xf7283160(0xd7a13ef0af8f1a1d1f15446b8426708be5a63fe31db67252e54f3c0b4e5fff45); /* statement */ 
uint32 nCheckpoints = numCheckpoints[account];
coverage_0xf7283160(0x3f69ab83e392af7326977361f62c0d9061272c62b16b02fb7d34168000362338); /* line */ 
        coverage_0xf7283160(0xed3d8640e55f871ef0c4b3654efaa995cc38da62a7a6babcc5417c171a5682e6); /* statement */ 
if (nCheckpoints == 0) {coverage_0xf7283160(0x8e96a15df9243d75667b181c6874a194e3314796149aa826b345e65b0d762032); /* branch */ 

coverage_0xf7283160(0xcc4315bdb9454fe9aac310b14603f8e77d7518ca2bbd654dd062757eb100f54c); /* line */ 
            coverage_0xf7283160(0x4b9bf1625ebbc1d097d33894decddf140c0d3907a0297279ca041038fa23c12f); /* statement */ 
return 0;
        }else { coverage_0xf7283160(0x7a093a20feefd6ffd144586e2f4d52f1e17a2c48befc8500b23cbd49903935bf); /* branch */ 
}

        // First check most recent balance
coverage_0xf7283160(0x57a3aca84c65a257fd0c097dfd965b5202ccb668e3a1db2aae1dc4ee95efe79b); /* line */ 
        coverage_0xf7283160(0x3e2163a55c56c9cf26b9fcc9a73bfafd36d37b6e851305293c48b28035e81811); /* statement */ 
if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {coverage_0xf7283160(0x5dcdd30c1ee24bd181baac857e8cea2d0a9ec7ab6ec19d883a42b46d59e7ab98); /* branch */ 

coverage_0xf7283160(0x7bc164ab84aa845d0ad577f5e59fb8d8c1901e6ba61278282a95c641c9224f7d); /* line */ 
            coverage_0xf7283160(0x1495a02c006bcbbdb6d69d6e53d9f5a0611f48b958cafcfdb984f5209ea9f963); /* statement */ 
return checkpoints[account][nCheckpoints - 1].votes;
        }else { coverage_0xf7283160(0x07d3b78e94909606821ec7d2f47777cc79d776286ae5fad894dfe76fc174d065); /* branch */ 
}

        // Next check implicit zero balance
coverage_0xf7283160(0x32b5de3737f510d2c4a94499413ac8188ecfe1e69bf6f9c6f853ba016e65e884); /* line */ 
        coverage_0xf7283160(0x14fe8201fd7385af0239f8b378bbb3ea2958da61891eaf1bcf6ff557baf50e63); /* statement */ 
if (checkpoints[account][0].fromBlock > blockNumber) {coverage_0xf7283160(0x06bb7734f3af2d3eae78e516a33835e36ffdb528ff4fd8fa6848feb12e92cd98); /* branch */ 

coverage_0xf7283160(0xabcceaa7105ef4e197c8fa701f1caff5bd06b875aec99da5c561f1a2d5ac1582); /* line */ 
            coverage_0xf7283160(0x84c3a5cab089fbad449039f50acf47d667ba8235661b59af6fe790ff58b6f0a7); /* statement */ 
return 0;
        }else { coverage_0xf7283160(0x5dbd0b32c1ff279c1b125974be2382bdf79b5622873878646074d30d167da8fc); /* branch */ 
}

coverage_0xf7283160(0xb6dac3c4644caa55fb4fecea47b38e25aa5d8198506e2fb39f1a5f27fb9d9aa8); /* line */ 
        coverage_0xf7283160(0xe57ff3ceba89fa1fedd1515b5f5cdce7e5149aa5a26e1a5273c5a619c174d800); /* statement */ 
uint32 lower = 0;
coverage_0xf7283160(0xd952c4fe43768e8b5f3c4d7a909690daf1c2cccd8be0226c91a8acccbb57df77); /* line */ 
        coverage_0xf7283160(0x0f8a749146310445e2867d7d0742d3f4261452ebbd378fabaae424fef21c5541); /* statement */ 
uint32 upper = nCheckpoints - 1;
coverage_0xf7283160(0x1180ed387b622dbbee807b85e01d2d580cf73bee39d01a606e664fe5f55ce0b7); /* line */ 
        coverage_0xf7283160(0xd7752d3226f61d4b248af8a7a2feafa3ec017f14c159edaef70c404694328ebb); /* statement */ 
while (upper > lower) {
coverage_0xf7283160(0x987db761a49fe48bae162d977b1cb185afe29ba2b67897280e1987155dbb99d9); /* line */ 
            coverage_0xf7283160(0xc473a669f6525b696fb72fadd0e63cac40804bd9255e1c97d43b9a1e1e0b8024); /* statement */ 
uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
coverage_0xf7283160(0x9858f116c04588ae07d8936494e9db1935c58f72fb52e746baa7b76157392291); /* line */ 
            coverage_0xf7283160(0x1a960cb803b2cd766dc74b5554e2563cdbffcb541f932316a2ab5ee97e071b33); /* statement */ 
Checkpoint memory cp = checkpoints[account][center];
coverage_0xf7283160(0x4927b1c7bbbe41a1be274a407c4c0292ef76aefeade479249c46e8453743a1da); /* line */ 
            coverage_0xf7283160(0xb0d859ff1f7066ec771f9c9e2272d84e887cf30eb86fa4b408987da98f2b7953); /* statement */ 
if (cp.fromBlock == blockNumber) {coverage_0xf7283160(0xddd93d0aaf3fc6c72692173fb631d4a169a39e23cb8ab2c6621ae512bb677975); /* branch */ 

coverage_0xf7283160(0x3c274a0f5202e71cd2bb5765a74907e388b7438e585ba65b4a1e5488b4f1c3fe); /* line */ 
                coverage_0xf7283160(0xe8891393b48f7651d274ec8159cfde1f2f89c05ebbab8155a6bbb675d27edbec); /* statement */ 
return cp.votes;
            } else {coverage_0xf7283160(0x7d580b3f20f84ccc410473f7d3008680ba3fa7ad446540e29dc289b48d2020cb); /* statement */ 
coverage_0xf7283160(0xaaac493312b90a2d2e56d9f7bcc8e988a68343e5c242f745ca294e36c532e8f4); /* branch */ 
if (cp.fromBlock < blockNumber) {coverage_0xf7283160(0xd94ff549ed7dcbb48b0b601dda102de1c2ea093615fd17d85cf4dc629a22158d); /* branch */ 

coverage_0xf7283160(0xfe93e37cc0ef0b975f96a1b3cd319c749ea6bf76c34128f884ca94d77a39f735); /* line */ 
                coverage_0xf7283160(0xb39a9636873b874ee16ba293573bba6be3833b3a772548e86867c22d8d94715e); /* statement */ 
lower = center;
            } else {coverage_0xf7283160(0x9dcd4c496c85c0a97e3e85ef3385820c53f2889261457bb2dcd384d8c6b2f205); /* branch */ 

coverage_0xf7283160(0x9af267915cb1dc9630330de865577e0ea577f6ffc6145c644fc7f6baa3ccd847); /* line */ 
                coverage_0xf7283160(0xd5fdcba907ec5536c4167a08a46769192224ff4a5382e0fd41899eae3ed20af1); /* statement */ 
upper = center - 1;
            }}
        }
coverage_0xf7283160(0x70bcd93c4548ed198c9f054271c9fc527f2ab83a3e4c57b2a298caddd627a4df); /* line */ 
        coverage_0xf7283160(0x3208c50db907eefd78ef6469e26d7422cc5c3056ffc9c5766525cdb2df476b32); /* statement */ 
return checkpoints[account][lower].votes;
    }

    function _delegate(address delegator, address delegatee) internal {coverage_0xf7283160(0xf6722b04060a9ba4ec98fb832c6352ebb0010a83d437d45fea1ea2b3fb956a81); /* function */ 

coverage_0xf7283160(0xb8681aa63a230f4aadeb9786a8e0822bb02dd77d337e15f00727ca3e1262febd); /* line */ 
        coverage_0xf7283160(0x45081bb1afc46a8509b6cf400268ed36401d54e97a6f113040e68ee1f153a6c6); /* statement */ 
address currentDelegate = delegates[delegator];
coverage_0xf7283160(0xf336f031a0385dbb6f6ad7fc05829a125cceab9fdd4a81fbefc6e4a9df4624fb); /* line */ 
        coverage_0xf7283160(0x2c25b4d09eb69af49ff0f0d9862ec2f589092e53b682296ecb4f80fc34d93810); /* statement */ 
uint96 delegatorBalance = balances[delegator];
coverage_0xf7283160(0x70d007b2378f876507e01f14edbdbaceb3bc7c1becf9b993bf40079e9016d1dd); /* line */ 
        coverage_0xf7283160(0x8a610f62c8be0eadec117b46a1b64e14d7298967c201ac50eec003f8be2c2985); /* statement */ 
delegates[delegator] = delegatee;

coverage_0xf7283160(0x70d85944e9cee0dcc7af75325e33cc4d5f5a26cdd35b458be8bdfb51295a5d49); /* line */ 
        coverage_0xf7283160(0x25ce9d96916726845eba747777e0676cf2796139cfc1d6014d1e1fe584b48a05); /* statement */ 
emit DelegateChanged(delegator, currentDelegate, delegatee);

coverage_0xf7283160(0x2e9d17e447bf3671c4e0c0616c3bb07d7cfd32c5637a8adec017cf79c26962e5); /* line */ 
        coverage_0xf7283160(0xa3320cc896c0716c52f34ef9fe0821ee7a6229435c68baed428ab6acd999d4d1); /* statement */ 
_moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _transferTokens(address src, address dst, uint96 amount) internal {coverage_0xf7283160(0x36d1d7df6ced7177c7cac24df6a1002b4b5505c08060efcff05e8862d0eecf89); /* function */ 

coverage_0xf7283160(0x21f14a160199bea96a350ddca73bd35ea6d3f3bd56c923ebf9f6266c080cdf0a); /* line */ 
        coverage_0xf7283160(0x8a6621c2468487c1907931955fc2100a507fc192a3205a6303fb85bddcf210e4); /* assertPre */ 
coverage_0xf7283160(0x27ab836fb4a00fb1c381ee8e914f91a71215bb201a9c0738f7b01b240dba5a7a); /* statement */ 
require(src != address(0), "SyncToken::_transferTokens: cannot transfer from the zero address");coverage_0xf7283160(0xd253f79b55f62711b7d9800f40bc76a9995ec0b8d5987bf2e0a954db7ee9b93f); /* assertPost */ 

coverage_0xf7283160(0x55c193d48a9f8925cb8acd2b4fa3dcd29a892d419202c82aede1b78184a7f8d6); /* line */ 
        coverage_0xf7283160(0xa6fb3091c844674ea8495111002095136d26e3bf929dca7f42eb8c4f3ae352ed); /* assertPre */ 
coverage_0xf7283160(0xfd70733508f294a274c30d343718d0b880d46ca60fd522679376d245d2bc07d3); /* statement */ 
require(dst != address(0), "SyncToken::_transferTokens: cannot transfer to the zero address");coverage_0xf7283160(0x14c5bf7b17931ab9e667f359efd01942e109530324202036525a9ddd8b068e63); /* assertPost */ 


coverage_0xf7283160(0x509c7b5d15791c2835430a0db86bb492702297cd7408ac23910fee81e936eb02); /* line */ 
        coverage_0xf7283160(0xb17bb29278b3aba203cad0a51d24561c5b1d00da8c58aa5c4089bcbb83f47260); /* statement */ 
balances[src] = sub96(balances[src], amount, "SyncToken::_transferTokens: transfer amount exceeds balance");
coverage_0xf7283160(0xb481a519e70552884055e663a22ccd522e99690070b13c07b57396726d819054); /* line */ 
        coverage_0xf7283160(0xa97765341da3106b618297b5f887c978816c890734117d54831183facaf4b122); /* statement */ 
balances[dst] = add96(balances[dst], amount, "SyncToken::_transferTokens: transfer amount overflows");
coverage_0xf7283160(0x9e4ddde34022c253aad4686e2836762d2be156b9274a3dda99bd649bf4933599); /* line */ 
        coverage_0xf7283160(0xb97ff97843b4be07e16305c5e7e3e5507f156487ec77d4f5b852c75deb8e5241); /* statement */ 
emit Transfer(src, dst, amount);

coverage_0xf7283160(0x3c31f054aa9a75d0a8a83dd3d152797e0e53294a825bdd49c8e3a2bb985f484a); /* line */ 
        coverage_0xf7283160(0xa0560d9b07abeb237f33a9efd11d717fed3adb116d92b2f8c414ae47c75cf072); /* statement */ 
_moveDelegates(delegates[src], delegates[dst], amount);
    }

    function _mintTokens(address dst, uint96 amount) internal {coverage_0xf7283160(0xed9a2c8853ceb183a9a9af1e7b85914719d816bda891f4e759d6059417628daa); /* function */ 

coverage_0xf7283160(0xf2ac5dd00686afad4de8e3f60bf30d393275b6c39cda2e26c4fdd41d1b397f52); /* line */ 
        coverage_0xf7283160(0xd304ee5d38cf88c8cc70ea57619bb57f4427ddf1456fb30ad5858d250ccbb564); /* assertPre */ 
coverage_0xf7283160(0xdd49afcf5bef747f788001a944d4ae3cf34b15a40171be368360ed27a8955fdd); /* statement */ 
require(dst != address(0), "SyncToken::_mintTokens: cannot transfer to the zero address");coverage_0xf7283160(0xc62eebb40ea584cd98b5ca1b22bbe10d0dbcabd94cbd6d8922156a04a87f80e4); /* assertPost */ 

coverage_0xf7283160(0x15ff276c78a2451e1df099eaffbb750ac0481adf1d3750d1e864a3c1b453c6fe); /* line */ 
        coverage_0xf7283160(0x2c5a7dc938c1b8e3c39acf2a08d73eddcda1657ae9b966837ce037eebfcfdf3d); /* statement */ 
uint96 supply = safe96(totalSupply, "SyncToken::_mintTokens: totalSupply exceeds 96 bits");
coverage_0xf7283160(0x040db89394fc37a10c2d3c16a841124e9fa2e9337fd5fa3af39348e55773749d); /* line */ 
        coverage_0xf7283160(0xebfc035b554079c91ea68037f234bb1bb3bd795b6388061dfc51396bc36656b2); /* statement */ 
totalSupply = add96(supply, amount, "SyncToken::_mintTokens: totalSupply exceeds 96 bits");
coverage_0xf7283160(0xda71f59f793c9ac81983d93acb4cf7502b7dbeeca39e65643b2216fc8862ec88); /* line */ 
        coverage_0xf7283160(0x9401c212e4ab000f3b6d60ea0ea8162564ade03f548bff5f38fb6516d943e469); /* statement */ 
balances[dst] = add96(balances[dst], amount, "SyncToken::_mintTokens: transfer amount overflows");
coverage_0xf7283160(0x2976be6f04ba4b16c5cfbc07fea01c3e0eaebf84c04cb18a3871074a01268e1a); /* line */ 
        coverage_0xf7283160(0x24a7c282bdae289ee954e965ef4bbe7b277666dc24bcb498089ebc867f941901); /* statement */ 
emit Transfer(address(0), dst, amount);

coverage_0xf7283160(0xc4d297aa154c954fee0185543960ccf635495c4bf5b79a7bd8a8dcaa567a01cd); /* line */ 
        coverage_0xf7283160(0xf478d0a6ff8c679e80382ed34f0b02e84421dedf0d9043cd4134b79a24cd0f92); /* statement */ 
_moveDelegates(address(0), delegates[dst], amount);
    }

    function _burnTokens(address src, uint96 amount) internal {coverage_0xf7283160(0xd66045078bdf6d14d0d5fe25303605ebd95f927dffcdbb1ec511b0b760f09825); /* function */ 

coverage_0xf7283160(0x6d51282c7ad242acacf4e46d3293a94fb32c53ae3ca9a2f7ce3cd4e3de8e22d7); /* line */ 
        coverage_0xf7283160(0x514f1e418036551583b25e56997e6245a1e461480d8f7a4a111e89882543fee6); /* statement */ 
uint96 supply = safe96(totalSupply, "SyncToken::_burnTokens: totalSupply exceeds 96 bits");
coverage_0xf7283160(0xb40337f4c02d8a504543fe096b6bac58d6db020b9cb0401ce59cb318987a6cae); /* line */ 
        coverage_0xf7283160(0x29c509e31ef7e80d1f72fdf2460ca5fc272ff8f461f9590c99d2c5c049d6cc68); /* statement */ 
totalSupply = sub96(supply, amount, "SyncToken::_burnTokens:totalSupply underflow");
coverage_0xf7283160(0xc8123ef51ccd5d2dd173580f7c1c5d8cff72a292f7e452390af8d469edddec48); /* line */ 
        coverage_0xf7283160(0xc2b50dd665c4e0e99b710da5a510901d638ae22bb34bcbee11094e6e5779de0c); /* statement */ 
balances[src] = sub96(balances[src], amount, "SyncToken::_burnTokens: amount overflows");
coverage_0xf7283160(0x464e230564f939bd0f3b20e6aa96f6bc4e7455b96fed6f85e83984fc1563c1d0); /* line */ 
        coverage_0xf7283160(0xc0e0979db6c651205cc0be268817cb1a583d11a8de65c02f64892fdfd49b296e); /* statement */ 
emit Transfer(src, address(0), amount);

coverage_0xf7283160(0xdf6f32746e2ddbb8e4ed935f3b3c7e730bf8753abca0f7abab58b660487bf581); /* line */ 
        coverage_0xf7283160(0x5f10fa78592f37649d71495f3bcf292e53379fc8d5fc32aaf46f847321d02bda); /* statement */ 
_moveDelegates(delegates[src], address(0), amount);
    }

    function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {coverage_0xf7283160(0xe7a3a853a2310410c0ca56e1ae10fece62f61bf179971fbed542344c23d04738); /* function */ 

coverage_0xf7283160(0xe7f75dd6f81e11842e34f98fdc1a2b90afff08fd31b3cf4f5b5afd4c2ec04410); /* line */ 
        coverage_0xf7283160(0x7446cf4c4f167c4384dd45259f2e5f546f989884c143da7563ba1fcf7304d289); /* statement */ 
if (srcRep != dstRep && amount > 0) {coverage_0xf7283160(0x98be750254cb89c6e19c696a46858e2d7b6aeb84990a02b2008739eec38fc527); /* branch */ 

coverage_0xf7283160(0x9bbc9501327b93ce7ad6e13280167678b4f3ac83702f85efc36959e5ea48b836); /* line */ 
            coverage_0xf7283160(0x9dd41eec1347d645a12364768e823fa9f50186e938b77a37f5d75e17e6bf9afc); /* statement */ 
if (srcRep != address(0)) {coverage_0xf7283160(0x0a867ff471dcfc7ddd4488e1ee1b8658cf5f1043d7e3061d47974d02c284567e); /* branch */ 

coverage_0xf7283160(0x5e122941685ef67d3578b5419025ac78322f1ead8570dd222ff3572478511e40); /* line */ 
                coverage_0xf7283160(0xf489c0df50555d6a4363bd86aa5ebe66a46aa9de7bef7ec6777e8d9f348e26d3); /* statement */ 
uint32 srcRepNum = numCheckpoints[srcRep];
coverage_0xf7283160(0x915381866321447b8f187720caaf9fa8e9b5d1b03bf295ff6f08e4604e683f7b); /* line */ 
                coverage_0xf7283160(0x083cd8fb7df1722c5681b89b62978a85f4e470d6432c1e0774a3af9ebd99f638); /* statement */ 
uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
coverage_0xf7283160(0x031212e643189f880fa700db03b102c7af7ef3812e0050bf001e6abd090e6864); /* line */ 
                coverage_0xf7283160(0x04b435b19306dc4b6a4247fe133b6bae3f78d4b58ea38992e72e725638d58f2a); /* statement */ 
uint96 srcRepNew = sub96(srcRepOld, amount, "SyncToken::_moveVotes: vote amount underflows");
coverage_0xf7283160(0xf30676dcf2f4d0db57728a891ddbd8f6a90f29af6b996213488d883de63f96e6); /* line */ 
                coverage_0xf7283160(0x41285eee91a99d9e28b6072f405a3dcaea122093ba8d3fefdf1d46a22c35ffcd); /* statement */ 
_writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }else { coverage_0xf7283160(0x6ea2bc2ebb465dfd84f62815dcc04cc23230a628783120104f9787767e29abd4); /* branch */ 
}

coverage_0xf7283160(0xd0ed0378a0b2f93752c2ea6e9efdd6e4e1ccfe1830dc5761ef50a1263b9dd5db); /* line */ 
            coverage_0xf7283160(0x421f334a058fdfc71a06bcedd1d699a63da782c3577cee6c5ed4f1cfb7a2bf8f); /* statement */ 
if (dstRep != address(0)) {coverage_0xf7283160(0xe30db98ff716152d3b3b6c86bac7741b28ccdcce5e8b9e048de7020fcd7009cc); /* branch */ 

coverage_0xf7283160(0xa2a906d84a7069832ebf061ae7e8315be691439b10787883759ad41fe4753c47); /* line */ 
                coverage_0xf7283160(0x8db951a8fa759c0a0f496a12f860de785d637431d6309a46ae60b35cba6893bf); /* statement */ 
uint32 dstRepNum = numCheckpoints[dstRep];
coverage_0xf7283160(0x65fc49dc2ff316ed4413d4d5e76e7156ecb91220f772c17dddda43fab8de8d91); /* line */ 
                coverage_0xf7283160(0x2108b94af1e585c5f7dd3fc38f14cc39e3d4ace30b874fcb5f993bef815f9221); /* statement */ 
uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
coverage_0xf7283160(0xbe4cef5be8bd16c1b89774fefa67b17c5b94a5657a83f008a519873e03a676bb); /* line */ 
                coverage_0xf7283160(0x4c523ebe51e251d3a8db0765a4312d6ebf208dd9acb808c1c306424ed445a3f4); /* statement */ 
uint96 dstRepNew = add96(dstRepOld, amount, "SyncToken::_moveVotes: vote amount overflows");
coverage_0xf7283160(0x723b6dbc6310c5e848f7d073fbaa7c3d84a6902781dc630630c782850cd9c7eb); /* line */ 
                coverage_0xf7283160(0x6d6bab9f0e2a0878ca7e01fce4412e57e7c756d26092da8e0a9f075183e01361); /* statement */ 
_writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }else { coverage_0xf7283160(0xa94ca845f015c5ede12e109572d0c741376e8caad08e10a587ad88c95b77a1bd); /* branch */ 
}
        }else { coverage_0xf7283160(0x005feb7e23412bfbb61265385fdd3ad3b4fe6116e7dd6c4e0bfbd0ef1a64f45b); /* branch */ 
}
    }

    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {coverage_0xf7283160(0xcdde70342b1fbd010481ea8861b4c6e14ac0f1d8b8cb5e78a9a5ab09d84f373c); /* function */ 

coverage_0xf7283160(0x8f487b1f529a892f192b809f0426c8ec2bda0f2db463569f084ed6fca091cb5b); /* line */ 
      coverage_0xf7283160(0x2b2eb1e7585388c4d7a0183d99dd2ce373285c151f56a989fb43203be10c5181); /* statement */ 
uint32 blockNumber = safe32(block.number, "SyncToken::_writeCheckpoint: block number exceeds 32 bits");

coverage_0xf7283160(0xcc662a538aafe2a298e93b4eae5b116ae6389c58785ea1d0e3fcf916554a68c4); /* line */ 
      coverage_0xf7283160(0xbcd829ad361a70501f044c29f3965e679a8b85dbbb48116da73089f09d32312c); /* statement */ 
if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {coverage_0xf7283160(0x9015231a229549b148253c8b9e03c7ae19545c449bce3bc6084a2731c8fbc51a); /* branch */ 

coverage_0xf7283160(0x92ddfd56632fdcbe228f636d0d2ab9366e1f6ac50313df87a954a6ef0833f02a); /* line */ 
          coverage_0xf7283160(0xbfb78c95b0ca1577c8a1a80de2600ebb574ded3cfb9d44415cbd3ee48587aa47); /* statement */ 
checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
      } else {coverage_0xf7283160(0x18d32732f39744122a90df54dcdb8052a0251851a70cbbd98d3f1a1039ebaa96); /* branch */ 

coverage_0xf7283160(0x7e04daf928454bf95aebf7fab1b9473dec816657620c669ad8fae39245e9ab09); /* line */ 
          coverage_0xf7283160(0xd64a187543bd6975f16708453eb1e6052479d3e4ce9236353779769dba92ff7c); /* statement */ 
checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
coverage_0xf7283160(0x949d951b2709007dab37c82b0a78c9fb7f3477e6734154f983a28672ce3b6624); /* line */ 
          coverage_0xf7283160(0x33dcabf6da6c3efb09f4a4de8f76e2d8040f89aec55228346611540f8324ef89); /* statement */ 
numCheckpoints[delegatee] = nCheckpoints + 1;
      }

coverage_0xf7283160(0xbd3167da8694e1506d70fc9b7b072966ed41f1ee388ae0bc4f099ab1817a8cce); /* line */ 
      coverage_0xf7283160(0xbe16a62dce999787d5d8599e37efa989a88fd731631ceb91b1b71a8c808865d5); /* statement */ 
emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {coverage_0xf7283160(0x500686d1b250313052d251259dafa36c1825adeeefce1b2e804a68ccb49a89d7); /* function */ 

coverage_0xf7283160(0x4008ecada68e04ef3821c77a2f25976a40135233b5c44eae8476da3e2e4e1502); /* line */ 
        coverage_0xf7283160(0x3acc58b93b9ba31c8ddfd55bc233b3ffa1ab4b3c13f2e38c99878670dec1d725); /* assertPre */ 
coverage_0xf7283160(0xa50e0740686a92613d684c479c48723c795115256fd8e176afb3c0db5690427a); /* statement */ 
require(n < 2**32, errorMessage);coverage_0xf7283160(0x03c74267a3f861c9e2fbd7636ae3d8856fae738ab8fb21ab868c39fe7cf269a4); /* assertPost */ 

coverage_0xf7283160(0xdfc7bf7134e7f57b45f90c8fbec15e51e1705426cd2951a772b92afeb016b940); /* line */ 
        coverage_0xf7283160(0xaf5f5d16eefd8bf3da718355e96cfd51399f132cacd72329710e4793b36d336e); /* statement */ 
return uint32(n);
    }

    function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {coverage_0xf7283160(0xafb9a491d298a3329478678ca424451aaead5c78deea4800c45a083d1b530530); /* function */ 

coverage_0xf7283160(0x536d9c56857647c9ee40f9ee589cc73e9d83b0e81ca67a04f8ba0f037825b907); /* line */ 
        coverage_0xf7283160(0x80849dbee07acd651e9fea5184e33ce81436bb2b0213dcffe4d99287d75e0a2c); /* assertPre */ 
coverage_0xf7283160(0x2b831945c3049421a9b77933c02846ab858994afb180b38ea4d005503e525fde); /* statement */ 
require(n < 2**96, errorMessage);coverage_0xf7283160(0x062869ce149caf1b988079bae5890ea1aa4b8bb4c934cfa559b4b806ce02957c); /* assertPost */ 

coverage_0xf7283160(0x87f438323545a940c2cbc061cec3c42b1612212ff73cda49a4755a859b43aa46); /* line */ 
        coverage_0xf7283160(0x26672f280e94c7daa7a4c11db813eb62ad9293ea211086c79db100dae95956fc); /* statement */ 
return uint96(n);
    }

    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {coverage_0xf7283160(0x64d3a93f833c703f544b63c4c070dabf6dc8837cb755efe5e6dacb590a114c23); /* function */ 

coverage_0xf7283160(0x3b4482757618d1b316538e470c42b97302c3e6ef3ae4afbdfc91c9848c232aee); /* line */ 
        coverage_0xf7283160(0x9fb4ccdf7081625a5bc814531b365745ae689ca41be42e40c1574f41d0e14de3); /* statement */ 
uint96 c = a + b;
coverage_0xf7283160(0xb96252df22664b27858df9572233de3479f2c83937d2dc49b6a0fcaa8c15e0f2); /* line */ 
        coverage_0xf7283160(0xe3d9154cf09b48904a0d3b77665f3581cc2e69e5a172156560ce4ffde1810cf8); /* assertPre */ 
coverage_0xf7283160(0x0cbf793539664bde383e80f2e2cec1369d57d7fd356425f52639f1867890e42f); /* statement */ 
require(c >= a, errorMessage);coverage_0xf7283160(0xdfa26bc9f1acaf748f3295da002433065a9317020e7e4f4651e61f4153c28012); /* assertPost */ 

coverage_0xf7283160(0x125566d517d6e8729e1b89b3a4f2e6064ddf5b1982f9d6b8cbcbd369d14cef4e); /* line */ 
        coverage_0xf7283160(0x872ed4d0fb42d7359b6bbc73296677d4604049867d66a3eb15efd6d1700824ea); /* statement */ 
return c;
    }

    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {coverage_0xf7283160(0x293cf4b29099756128a6e9ffd7e6c07a72a677f24cd16c1f47fb3e7dd717323e); /* function */ 

coverage_0xf7283160(0xe629c91d190ec2e29681d3e77665726388789b384bc8eb70c17b081b2eb55447); /* line */ 
        coverage_0xf7283160(0xaa62cc3231a8fdc99da785e44be3ce055790535c710c07da0ae56fcd2f374bd9); /* assertPre */ 
coverage_0xf7283160(0x21a9760a8c5a9da7f99ae44d97cf0c3ed1528168b3df77c4cda030d063c3a4f7); /* statement */ 
require(b <= a, errorMessage);coverage_0xf7283160(0x76829a944b3f1cfc7d1554e3700bb834358b548045288095670859ddc3210641); /* assertPost */ 

coverage_0xf7283160(0xe981666792767cc4364b7cc8bd41cb1921fd617fd3bca104f2c6c67e1a432153); /* line */ 
        coverage_0xf7283160(0xb2dc907c25404f42ced4056c37afd448c58bb1cebf8986811f02631bade690b8); /* statement */ 
return a - b;
    }

    function getChainId() internal pure returns (uint) {coverage_0xf7283160(0xfe1e7d7a38e091958b3d58ea318a1a80b79b465ee701d070e5e9a043922441fe); /* function */ 

coverage_0xf7283160(0xb35a0fdb9c70c49029905e85c42ce5caf8128a3e107b2c58ec24d9060064db3c); /* line */ 
        coverage_0xf7283160(0x84553f1f5e3e880e2f434591e5b3572136c02614eb832d26e178cf004dee25ce); /* statement */ 
uint256 chainId;
coverage_0xf7283160(0xe6c52b9e3e6191e4f28bdf3921ab431bdba7f301fc6e9d3a7ac83bf180e2aa1b); /* line */ 
        assembly { chainId := chainid() }
coverage_0xf7283160(0xa8d99a1c469833c2af183bc03a58d29b1d74c413e4d6407bfefd649fb25fdce6); /* line */ 
        coverage_0xf7283160(0x939ee25ae0cf701917d2a847d3e2a5f8579c5f531d6394eaed71d0ed9a67dd1e); /* statement */ 
return chainId;
    }
}