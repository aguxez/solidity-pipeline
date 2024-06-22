// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Counter is UUPSUpgradeable, Initializable {
    uint256 public number;
    address upgrader;

    error InvalidUpgrader();
    error InvalidImplementation();

    function initialize(address upgrader_) initializer external {
      if (upgrader_ == address(0)) revert InvalidUpgrader();

      upgrader = upgrader_;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function _authorizeUpgrade(address newImpl) internal view override {
      if (newImpl == address(0)) revert InvalidImplementation();
      if (msg.sender != upgrader) revert InvalidUpgrader();
    }
}
