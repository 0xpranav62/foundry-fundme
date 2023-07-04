// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

// This contract help to configure network address

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }
    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaNetwork();
        }
        else{
            activeNetworkConfig = getAnvilNetwork();
        }
    }
    function getSepoliaNetwork() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaNetworkConfig;
    }
    function getAnvilNetwork() public returns(NetworkConfig memory){
        // 1.Deploy the mock contract
        // 2.Use the contract address in local setup
        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3priceFeed = new MockV3Aggregator(8,2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilNetworkConfig =  NetworkConfig({priceFeed: address(mockV3priceFeed)});
        return anvilNetworkConfig;
    }

}