pragma solidity ^0.5.16;

/*
The MIT License (MIT)

Copyright (c) 2018 Murray Software, LLC.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//solhint-disable max-line-length
//solhint-disable no-inline-assembly

contract CloneFactory {
function coverage_0x2b8c3e74(bytes32 c__0x2b8c3e74) public pure {}


    function createClone(address target) internal returns (address result) {coverage_0x2b8c3e74(0xc6d7455e634ac0f478954d8e3cabb737e87b5658bb0a93f8a72be65b4803550f); /* function */ 

coverage_0x2b8c3e74(0xeddf29419cb698c06e2a7b657350e9e75ae96460178d26d70dcebc43eae4d901); /* line */ 
        coverage_0x2b8c3e74(0x60895db440fb4f648a0b57d472affb046a030d66b1b72895c6cc7aec001d0a19); /* statement */ 
bytes20 targetBytes = bytes20(target);
coverage_0x2b8c3e74(0x38dd34acfead82cb1f3dfe31465f1d0c8da18df0705d398b983622e8dac601ce); /* line */ 
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }
}
