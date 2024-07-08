// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";
import "../src/BuyMyTime.sol";

contract BuyMyTimeDeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        BuyMyTime buyMyTime = new BuyMyTime("captn", "CAPTN", 0xC1200B5147ba1a0348b8462D00d237016945Dfff);

        vm.stopBroadcast();
        console2.log("BuyMyTime address: ", address(buyMyTime));
    }
}

// forge script script/BuyMyTime.s.sol:BuyMyTimeDeployScript --broadcast --rpc-url base_sepolia
