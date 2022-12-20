// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {CircleIntegrationImplementation} from "../src/circle_integration/CircleIntegrationImplementation.sol";

contract ContractScript is Script {
    function run() public {
        // begin sending transactions
        vm.startBroadcast();

        // deploy new implementation
        CircleIntegrationImplementation implementation = new CircleIntegrationImplementation();
        console.log("CircleIntegrationImplementation:", address(implementation));

        // finished
        vm.stopBroadcast();
    }
}
