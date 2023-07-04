/*This script is use to interact with fund and withdraw function*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {fundme} from "../src/fundme.sol";
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    function fundFundMe(address mostRecentDeployedContract) public {
        vm.startBroadcast();
        fundme(payable(mostRecentDeployedContract)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external { 
        address mostRecentDeployedContract =  DevOpsTools.get_most_recent_deployment(
            "fundme",
             block.chainid
        );
        fundFundMe(mostRecentDeployedContract);
    }

}
contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostRecentDeployedContract) public {
        vm.startBroadcast();
        fundme(payable(mostRecentDeployedContract)).withdraw();
        vm.stopBroadcast();
    }

    function run() external { 
        address mostRecentDeployedContract =  DevOpsTools.get_most_recent_deployment(
            "fundme",
             block.chainid
        );
        
        withdrawFundMe(mostRecentDeployedContract);
        
    }

}
