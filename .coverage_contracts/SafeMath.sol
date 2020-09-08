pragma solidity ^0.5.16;

// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
// Subject to the MIT license.

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
function coverage_0x9b524d23(bytes32 c__0x9b524d23) public pure {}

    /**
     * @dev Returns the addition of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {coverage_0x9b524d23(0xdb85f0df4afe45e0ad98a7443716e7f2cba32d5db2e2721d9c2c084428fa7c44); /* function */ 

coverage_0x9b524d23(0xe0860356e0059cacc8b3591c9d224dc6e9cf33918d7c331ccdd50b82e58ca1a6); /* line */ 
        coverage_0x9b524d23(0x78f5a567d4f2341dff00da28d111a55653dc15e3ed27753f84fd9dd9e892d66c); /* statement */ 
uint256 c = a + b;
coverage_0x9b524d23(0xa58196f6ab779c80677472b2f7e5dd5d06b649a3bd487626a9a39f4d167502c3); /* line */ 
        coverage_0x9b524d23(0xb22264bb9c2b03c1a8a48f506d8bf1fcdadad34921124ef3446658a1c5feb331); /* assertPre */ 
coverage_0x9b524d23(0x01409a3eb28b2297b9259379097778722255ad08455eb3baae2d1bfef49b69bb); /* statement */ 
require(c >= a, "SafeMath: addition overflow");coverage_0x9b524d23(0x7706d1e6a4551bb89be17f8bab27d45fc4519355fcc9d199914c9190911b844a); /* assertPost */ 


coverage_0x9b524d23(0x1ea6ec5d616d64fccc54765c0e859a39cde1b81fb50fdd6bda257bb733993222); /* line */ 
        coverage_0x9b524d23(0x10474bb208a9d9ae7c9878ff51f9db9899dc048e904a75a99af6b6cf63482ef5); /* statement */ 
return c;
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {coverage_0x9b524d23(0xa2bb7e2752758177e52966cb778deb2f2170b5b3a3ba35ed6f9e7e37de2a2e91); /* function */ 

coverage_0x9b524d23(0x8dcfad474045203d726b92b362f4e9a708872ab108c0acb68797171ce6a72f7a); /* line */ 
        coverage_0x9b524d23(0x9f9adbc9628ce291b7de63bf82d2c3b4f1074fb204f1763f3ba5a3c3dc62f3fc); /* statement */ 
uint256 c = a + b;
coverage_0x9b524d23(0x06d8bee0063e61afe91aa9f0a6ddecb0aaa430ffa65b0cc5b7ab85398aac74f3); /* line */ 
        coverage_0x9b524d23(0x22d45b2fcbb23bdfb01f62f8bfa126f05a178c12a33a357ec44897079e44697e); /* assertPre */ 
coverage_0x9b524d23(0x4cfe791be819b444a60e7a903beda767802b21c4c5b0a73da9d0c7b55613455c); /* statement */ 
require(c >= a, errorMessage);coverage_0x9b524d23(0x17ca47993e42a90b72261bf40a14bed79962f571169298e59b0346d8d2c8e97d); /* assertPost */ 


coverage_0x9b524d23(0x70667d299b12ca7b333b1ff2158b01e683f29e764abec5906aeeddfc62bc8331); /* line */ 
        coverage_0x9b524d23(0x428251b2631fa7cc4c018cb3a65111bce2acee6588188254fa7d5a3a0a8c86c7); /* statement */ 
return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot underflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {coverage_0x9b524d23(0x20fa5286aaf5bbc75e95eb98eea48cb03d0980ff7c0697bcd1245315d8fbd0c8); /* function */ 

coverage_0x9b524d23(0x48539a23dc4514f7bbc4763538e9a16b7b522650adf83ed1cd3df1938d258b06); /* line */ 
        coverage_0x9b524d23(0x5302f57314d848a85ce8d852cc47e5f37bcfd0e2d456ec7aaf59e30a612b7c85); /* statement */ 
return sub(a, b, "SafeMath: subtraction underflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot underflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {coverage_0x9b524d23(0xd136f86d669985f307a94684fff6c79ab38abe800012dadcc70395648f3f1982); /* function */ 

coverage_0x9b524d23(0xc5e4e3c157401735ae085021d2a0f8d38dc892a17de175381fbcfbb2c984dc10); /* line */ 
        coverage_0x9b524d23(0x6127aa4bec2eb593f0fed082f6b27dc3b224b9dbb6cc4688e5b43f80c206940d); /* assertPre */ 
coverage_0x9b524d23(0x0339ffefbf89e28518834973a382f0aab7d66b98162db40a88cf7260f061760e); /* statement */ 
require(b <= a, errorMessage);coverage_0x9b524d23(0x011deedec689166b9373b4efa8cdcac74f7f3d2c63bc40a4000ff4e5321d9f81); /* assertPost */ 

coverage_0x9b524d23(0x689b45ce9748e585b3523fcf4194f3559ae735acbd3bcc23f8c8a5f60cd445ad); /* line */ 
        coverage_0x9b524d23(0xcacc867db0d4d2a7b99e36356b79f13000aa937c27936fabb52c7711bbc97065); /* statement */ 
uint256 c = a - b;

coverage_0x9b524d23(0xfef002d22c6c9fc333ac39a73d92888fd4a32f166e767d20524adcbefec1ad3f); /* line */ 
        coverage_0x9b524d23(0x52e936768bb0369210c4f7e74e92dae2f5206837319799f02ccfa918bf8d1920); /* statement */ 
return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {coverage_0x9b524d23(0xdacd98f73c5e525ecde2ef65edd856410e0c1a03c05cdd522ac14dbd5d3f051a); /* function */ 

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
coverage_0x9b524d23(0xc89c3ab6660207846318d2a837bd183baa5946ad7207b77f257a0d8f94cc7648); /* line */ 
        coverage_0x9b524d23(0x692f9af1ac56c196ec1de1cfa1a063a711863a7158aa229c432b9662c965e785); /* statement */ 
if (a == 0) {coverage_0x9b524d23(0x41531f768d01ee858bdc3d7abbbeabd0a939a3af545a6252bc13f9977d9bae82); /* branch */ 

coverage_0x9b524d23(0xbd7365e21c033b92cc95255864d2b583260ba8f271976c0edd221a899b78c146); /* line */ 
            coverage_0x9b524d23(0x574eab6c0a81fdd137d8a4aa73df822166afb6b160cf81fe4b8a94366a951a7c); /* statement */ 
return 0;
        }else { coverage_0x9b524d23(0x4cfea1255d105a9f53a445d1e7e7ff9cce5f57153a6f05634a31f8aa08a5c8d2); /* branch */ 
}

coverage_0x9b524d23(0xd767968a9f16c68e34feaa1251697851bf04f1be20ab1d180f5dbc77306d2001); /* line */ 
        coverage_0x9b524d23(0x710dc4a990887885402b237ff9f1798858b9681dec4bcce4993dc9c4a869ccba); /* statement */ 
uint256 c = a * b;
coverage_0x9b524d23(0x74f1ea8e0bbf3e8b0c763e95a15f186bdbeb3504e0f997cfc6cdb6e366ccb056); /* line */ 
        coverage_0x9b524d23(0x1ec56ef6953d17a0c36a3954f03963f585750718129156e17a06ea2fee2b0625); /* assertPre */ 
coverage_0x9b524d23(0xf9d986c49aceb0ac55babeafc8a68d8937aadf01edeb6646365083d86d9ac615); /* statement */ 
require(c / a == b, "SafeMath: multiplication overflow");coverage_0x9b524d23(0x73cf7e263f593c8a3eb698f88d73de717edb918c4b728838e4de1dc86e8c6865); /* assertPost */ 


coverage_0x9b524d23(0x3032da012be6b61a750067f4666a653e00e3b1b277905854c744f85b7647cfde); /* line */ 
        coverage_0x9b524d23(0x9071cc83f2ba55e8ffd4a840e7802c557fee5bfa4932114b74a02aa3cceace03); /* statement */ 
return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {coverage_0x9b524d23(0x192253bdd47f5217942b24921fb1985f1113cbcfcb8f2c1810a914b946b2e0cc); /* function */ 

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
coverage_0x9b524d23(0xb4fbd44a6d32a7f97ba84e883578a6316372f83b65b2da3788bf03427c3981b5); /* line */ 
        coverage_0x9b524d23(0x4bd953549ca25ca4c01987f9d739ac6abd3ac15e43e4cbfa32aae912c13caedc); /* statement */ 
if (a == 0) {coverage_0x9b524d23(0x77b3a69b8d7b7f0595173f8a6ab94f0b38b28b484fae6ea875c0043fa32733ed); /* branch */ 

coverage_0x9b524d23(0xdac1b0fb66ccc322ac41e0639917a89a9f5bbe250a54b0d71c7c0d303a0a68d1); /* line */ 
            coverage_0x9b524d23(0x1a0e5213d6a73b2abd0553ec8cda084dcf7630500c3e292df21d96c41e7fa2da); /* statement */ 
return 0;
        }else { coverage_0x9b524d23(0x97b1a19d79b987858ab85d0c464da69afd7f76cf54e5dade8062fbd8ea8eef55); /* branch */ 
}

coverage_0x9b524d23(0x8b03b948ae3b4b3bf5fee0a0fa7975efd46b4816cfe96315070954db43ed1db1); /* line */ 
        coverage_0x9b524d23(0x4334c15b79a079324ca61dfbc21295c4516a988216211e2383d63b1660677385); /* statement */ 
uint256 c = a * b;
coverage_0x9b524d23(0xe84ba60302b90ba7d8a587cc12cb5152d1da16c6f92d35a1901064fd9e041dd2); /* line */ 
        coverage_0x9b524d23(0x5499180c34ede2d94c95b8d3ae528a29d1c16e6ddd92f5985f7687452f927a7b); /* assertPre */ 
coverage_0x9b524d23(0xd8272e5e3910c7d1d4ad33e43997760ba4ecc28aa20faeeafda8217bc1a7e2c7); /* statement */ 
require(c / a == b, errorMessage);coverage_0x9b524d23(0xb29ecf9207cbe4cc7a642882edffd20f3af99a54e896dcd2691783c732dfcc0e); /* assertPost */ 


coverage_0x9b524d23(0x1cbf49d2ddf7f2331c46e96332ff53dd1de5eaf85de1d27f68def27489d93353); /* line */ 
        coverage_0x9b524d23(0xb642c8b5d786aec13b1ef2f47745410c0044c296f7be6bfd4ee18ecc309f2b6b); /* statement */ 
return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers.
     * Reverts on division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {coverage_0x9b524d23(0x4d7fc518605a70eddf5d936600e195906aefb84e210373b0ed86799c6dc9559b); /* function */ 

coverage_0x9b524d23(0x9ba07f8b13cb732d05563e5ad7d23ce5db7d860ebdc531c868c062cd0481d393); /* line */ 
        coverage_0x9b524d23(0x85ec12f9ed9637848aa6495a80bf15732624bf0cc59233a0131849a99b3e26e2); /* statement */ 
return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers.
     * Reverts with custom message on division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {coverage_0x9b524d23(0xd841b2e5337e9f7ad8e520f2a7b56fec7e4ceaef461a68a3372aab4906cb015b); /* function */ 

        // Solidity only automatically asserts when dividing by 0
coverage_0x9b524d23(0x5c9274a7b1f38adfd7331a8c30816952e29bd1face98bcbb7b7eb4f427bcd89b); /* line */ 
        coverage_0x9b524d23(0xcaf612ade494e9580ed9e97f5dd189c719727f19f99d28a6a32d7dc972b09b83); /* assertPre */ 
coverage_0x9b524d23(0xb5e219b84fcf8cada660eaf3ce311b5c296ba64beff8e1b31d1832a59a8a89de); /* statement */ 
require(b > 0, errorMessage);coverage_0x9b524d23(0xea2882368155248cdff4399367501c78f8547a4afdb16899f9b78c1d8c8b7439); /* assertPost */ 

coverage_0x9b524d23(0x13d9ebab6d11eb0539612f5b528b4c183f36978334fa6ab4037519d0dde16300); /* line */ 
        coverage_0x9b524d23(0x49712baabe1f1e3439c6673625bb3c1a898d5e0ead71ce5d63e9152f9502d332); /* statement */ 
uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

coverage_0x9b524d23(0x6231308910d875f0a8420b6305aea63d846714a2ef2daa2848123bd7a21101a4); /* line */ 
        coverage_0x9b524d23(0xd07552fc522f6efc8b3f660a8984bc0d648839a6ccafb400ebe9bb1832dbabd9); /* statement */ 
return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {coverage_0x9b524d23(0xbe12a13026a175c2ce33b016382d835901d739fa14524b5c69a76ee56c610c8e); /* function */ 

coverage_0x9b524d23(0xf808a9030736bf0e1eae796ca2b17b017c4ebf1ec9a9b8082d2327c4d5f3dff8); /* line */ 
        coverage_0x9b524d23(0xef61226d69007ad6e61ad5dba7b59abfe30be079d20c2a89abe86ba05e2d3937); /* statement */ 
return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {coverage_0x9b524d23(0x65fdddcc8afa51b8ad56f6782dc0041baae9035a8ab4bbd81ffc356af40bc780); /* function */ 

coverage_0x9b524d23(0x5c249802bb94a3e5cb0f220652fe72097a72455b41d0ea2f39085c22b400cf1a); /* line */ 
        coverage_0x9b524d23(0x21c4b07ebee02dd2f9809886082c4997c8455ea04d33aa604250f182b17ecee2); /* assertPre */ 
coverage_0x9b524d23(0x45ee87841ecc437faf1b69adc63064a313a32e7909d317f79e55cbf88c701759); /* statement */ 
require(b != 0, errorMessage);coverage_0x9b524d23(0xdba65a22a3bf055d590f97221497afc88e0ac845dfce657bdac47c17dd5d557c); /* assertPost */ 

coverage_0x9b524d23(0x0a8a959ef4a3f4fb1230fa73e50a17193ff43319ebf5d9def3b2a30a76b41edd); /* line */ 
        coverage_0x9b524d23(0xec9d26d1d5dccc6669a24b19b3b517ba1c65cea9db488fe019a1e305af581234); /* statement */ 
return a % b;
    }
}