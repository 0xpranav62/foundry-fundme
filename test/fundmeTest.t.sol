// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {fundme} from "../src/fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract fundmeTest is Test {
    fundme fundMe;
    uint256 Send_value = 0.1 ether;
    address USER = makeAddr("user");
    uint256 USER_Start_Balance = 10 ether;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); 
        vm.deal(USER,USER_Start_Balance);
        
    }
    function testMinUSDIsEqualFive() public {
        assertEq(fundMe.Minimium_USD(), 5e18);
    }
    function testOwnerIsMsgSender() public {
        // us calling Fundme test -> fundme So we are calling fundme contract through FundMetest thats why different addresses
        assertEq(fundMe.getOwner(),msg.sender);
    }
    function testGetVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundAmtIsGreaterThanMinUSD() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundAddressIsUpdated() public {
        vm.prank(USER);
        fundMe.fund{value: Send_value}();
        uint256 fundedAmt = fundMe.getAddressToAmtFunded(USER);
        assertEq(fundedAmt, Send_value);

    }

    function testFunderArrayIsUpdated() public {
        vm.prank(USER);
        fundMe.fund{value: Send_value}();
        address FunderAddress = fundMe.getFunder(0);
        assertEq(USER, FunderAddress);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: Send_value}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawForSingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBal = fundMe.getOwner().balance; 
        uint256 startFundMeBal   = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        // Assert
        uint256 endingOwnerBal  = fundMe.getOwner().balance;
        uint256 endingFundMeBal = address(fundMe).balance;
        assertEq(endingFundMeBal, 0);
        assertEq(startingOwnerBal + startFundMeBal, endingOwnerBal);


    }

    function testcheapWithdrawFromMultipleFunders() public funded {
           // First create array for funder address
        uint160 startingIndex = 1;
        uint160 numberOfFunder = 10; // solidity doesnot allow casting uint256 to type address, uint160 contains exact number of bytes as address type;

        for(uint160 i = startingIndex; i < numberOfFunder; i++){
            hoax(address(i), Send_value); // hoax does same work as prank + deal
            fundMe.fund{value: Send_value}();
        }

        uint256 startingOwnerBal  = fundMe.getOwner().balance;
        uint256 startingFundMeBal = address(fundMe).balance; 

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.cheapwithdraw();

        // Assert
        uint256 endingFundMeBal = address(fundMe).balance;
        uint256 endingOwnerBal  = fundMe.getOwner().balance;

        assertEq(endingFundMeBal, 0);
        assertEq(startingOwnerBal + startingFundMeBal , endingOwnerBal);



    }
    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        // First create array for funder address
        uint160 startingIndex = 1;
        uint160 numberOfFunder = 10; // solidity doesnot allow casting uint256 to type address, uint160 contains exact number of bytes as address type;

        for(uint160 i = startingIndex; i < numberOfFunder; i++){
            hoax(address(i), Send_value); // hoax does same work as prank + deal
            fundMe.fund{value: Send_value}();
        }

        uint256 startingOwnerBal  = fundMe.getOwner().balance;
        uint256 startingFundMeBal = address(fundMe).balance; 

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingFundMeBal = address(fundMe).balance;
        uint256 endingOwnerBal  = fundMe.getOwner().balance;

        assertEq(endingFundMeBal, 0);
        assertEq(startingOwnerBal + startingFundMeBal , endingOwnerBal);




    }
}
