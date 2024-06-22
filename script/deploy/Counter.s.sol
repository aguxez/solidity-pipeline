// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../../src/Counter.sol";
import {CounterProxy} from "../../src/CounterProxy.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {DeployValidator} from "../DeployValidator.s.sol";

// This script should be called only when you want to upgrade.
// Ensuring the contract hasn't been deployed can be done by sourcing the environment
// with the known addresses. They can be picked up from the 'broadcast' folder with the
// 'run-latest' file, for example.
contract Upgrade is Script, DeployValidator {
    error ProxyNotDeployed();

    function setUp() public view {
        // Ensure the proxy has been deployed already. It is the duty of the caller to ensure the address
        // is correct.
        if (!isDeployed("CounterProxy")) revert ProxyNotDeployed();
    }

    // Only deploy the implementation and handle the rest through the Safe
    function run() public {
        uint256 deployerPk = vm.envUint("DEPLOYER_PK");

        vm.startBroadcast(deployerPk);

        new Counter();
    }
}

// TODO: Handle upgrades
contract Deployment is Script, DeployValidator {
    function setUp() public {}

    function run() public {
        if (isDeployed("Counter")) return;
        if (isDeployed("CounterProxy")) return;

        uint256 deployerPk = vm.envUint("DEPLOYER_PK");
        address safeAddress = vm.envAddress("SAFE_ADDRESS");

        vm.startBroadcast(deployerPk);

        // Deploy implementation and initialize it through the deployer
        Counter counter = new Counter();

        // Deploy the proxy and set the implementation
        bytes memory proxyData = abi.encodeWithSelector(
            counter.initialize.selector,
            safeAddress
        );
        CounterProxy counterProxy = new CounterProxy(address(counter), proxyData);

        console.logString(
            string(
                abi.encodePacked(
                    "Counter implementation: ",
                    Strings.toHexString(address(counter))
                )
            )
        );

        console.logString(
            string(
                abi.encodePacked(
                    "Counter Proxy: ",
                    Strings.toHexString(address(counterProxy))
                )
            )
        );

        vm.stopBroadcast();
    }
}
