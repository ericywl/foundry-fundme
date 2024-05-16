// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fund(address deployed) public {
        vm.startBroadcast();
        FundMe(payable(deployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        fund(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdraw(address deployed) public {
        vm.startBroadcast();
        uint256 balance = payable(deployed).balance;
        FundMe(payable(deployed)).withdraw();
        vm.stopBroadcast();

        console.log("Withdrew FundMe with %s", balance);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        withdraw(mostRecentlyDeployed);
    }
}
