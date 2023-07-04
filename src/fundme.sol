// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConvertor} from "./PriceConvertor.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract fundme {
    //  This function funds the smart contract
    using PriceConvertor for uint256;

    uint256 public constant Minimium_USD = 5e18;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    //For constructor 
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {

       i_owner = msg.sender;
       s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= Minimium_USD, "Didn't send enough ethereum, Are you poor fam??"); // Reverts the function if enter value is less than minimium value;
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
    }
    function getVersion() public view returns(uint256) {
        return s_priceFeed.version();
    }

    function cheapwithdraw() public onlyOwner {
        uint256 FunderLength = s_funders.length;
        for( uint256 funderIndex = 0 ; funderIndex < FunderLength ; funderIndex++){
            s_addressToAmountFunded[s_funders[funderIndex]] = 0;
        }
           s_funders = new address[](0);

        //  msg.sender = address type
        // payable = payable address type

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!!!");

    } 
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address FunderAddress = s_funders[funderIndex];
            s_addressToAmountFunded[FunderAddress] = 0;
        }

        s_funders = new address[](0);

        //  msg.sender = address type
        // payable = payable address type

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!!!");
    }

    modifier onlyOwner() {
        require(i_owner == msg.sender, "Withdraw function can only be used by owner address");
        _;
    }


    /*Getter functions for private variables */
    function getFunder(uint256 index) view external returns(address){
        return s_funders[index];
    } 

    function getAddressToAmtFunded(address FunderAddress) view external returns(uint256){
        return s_addressToAmountFunded[FunderAddress];
    }

    function getOwner() view external returns(address) {
        return i_owner;
    }


}
