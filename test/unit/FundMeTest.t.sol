// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FoundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FoundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(msg.sender);
        console.log(fundMe.getOwner());
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testAddressToAmountFundedIsUpdate() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountToFund(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFounderToArrayFounders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address founder = fundMe.getFounder(0);
        assertEq(founder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testIfWithdrawWithSingelFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testWithrawWithMultipleFunders() public {
        // Arrange
        uint160 amountOfFunders = 10;
        uint160 startedFundingIndex = 1;

        for (uint160 i = startedFundingIndex; i < amountOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Act
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundedBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            fundMe.getOwner().balance ==
                startingFundedBalance + startingOwnerBalance
        );
    }

    function testWithrawWithMultipleFundersCheaper() public {
        // Arrange
        uint160 startedFundingIndex = 1;
        uint160 amountsOfFunders = 10;

        for (uint160 i = startedFundingIndex; i < amountsOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();

            // Act
            uint256 startingOwnerBalance = fundMe.getOwner().balance;
            uint256 startingFundedBalance = address(fundMe).balance;

            vm.startPrank(fundMe.getOwner());
            fundMe.withdraw();
            vm.stopPrank();

            // Assert
            assert(address(fundMe).balance == 0);
            assert(
                fundMe.getOwner().balance ==
                    startingOwnerBalance + startingFundedBalance
            );
        }
    }
}
