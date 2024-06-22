// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";
import {CounterProxy} from "../src/CounterProxy.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// TODO: Handle upgrades
contract CounterScript is Script {
    function setUp() public {}

    function run() public {
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
