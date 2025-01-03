pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { Kevin } from "contracts/Kevin.sol";
import { NoirHelper } from "foundry-noir-helper/NoirHelper.sol";

contract KevinTest is Test, NoirHelper {
    Kevin kevin;
    NoirHelper noirHelper;

    function setUp() external {
        kevin = new Kevin();
        noirHelper = new NoirHelper();
    }

    function _sheesh(string memory name) internal {
        // Because the proof generally contains both the proof itself and all public inputs,
        // `publicInputSize` is set to 3, which is the expected number of public inputs in the generated proof file.

        // This Noir circuit has two public inputs and one public return value.
        // In the `Nargo.toml` file, you only need to specify the two public inputs;
        // the return value is automatically derived by Noir and included in the generated proof.
        uint256 pubInputSize = 3;
        noirHelper.withInput("x", 1).withInput("y", 2);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProofAndClean(name, pubInputSize);
        bytes32[] memory inputs = new bytes32[](3);
        inputs[0] = bytes32(uint256(1));
        inputs[1] = bytes32(uint256(2));
        inputs[2] = bytes32(uint256(3));
        kevin.set(proof, inputs);
        assertEq(kevin.last(), 3);
        for (uint256 i = 0; i < pubInputSize; i++) {
            assert(publicInputs[i] == inputs[i]);
        }
    }

    function testLabouji() external {
        _sheesh("test_0");
    }

    function testKingBob() external {
        _sheesh("test_1");
    }
}