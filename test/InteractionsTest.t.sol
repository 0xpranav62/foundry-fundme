// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
import {Test} from "forge-std/Test.sol";
import {fundme} from "../src/fundme.sol/";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../script/Interactions.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract InteractionsTest is Test {
     fundme fundMe;
    uint256 Send_value = 0.1 ether;
    address USER = makeAddr("user");
    uint256 USER_Start_Balance = 10 ether;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); 
        vm.deal(USER,USER_Start_Balance);
    }

    function testFundAndWithdrawInteraction() public {
        FundFundMe fundfundMe = new FundFundMe();
        fundfundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawfundMe = new WithdrawFundMe();
        withdrawfundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
        
    }
}