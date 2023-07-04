// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {fundme} from "../src/fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns(fundme){
        HelperConfig helperConfig = new HelperConfig();
        address EthUSDpriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        fundme fundMe = new fundme(EthUSDpriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}