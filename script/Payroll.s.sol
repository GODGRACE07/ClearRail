// SPDX-License-Identifier: MIT
pragma solidity ^0.8.36;

import {Script, console} from "forge-std/Script.sol";
import {Payroll} from "../src/Payroll.sol";

contract DeployPayroll is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);
        Payroll payroll = new Payroll(tokenAddress);
        vm.stopBroadcast();

        console.log("Payroll deployed at:", address(payroll));
    }
}
