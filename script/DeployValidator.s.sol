// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract DeployValidator is Script {
    function isDeployed(string memory contractName) internal view returns(bool) {
        address contractAddress = vm.envOr(contractName, address(0));

        return contractAddress != address(0);
    }
}
