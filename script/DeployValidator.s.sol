// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

contract DeployValidator is Script {
    function isDeployed(string memory contractName) internal view returns(bool) {
        return vm.envOr(contractName, address(0)) != address(0);
    }
}
