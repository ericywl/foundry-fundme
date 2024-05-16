// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address TEST_USER = makeAddr("test-user");
    uint256 constant STARTING_VALUE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(TEST_USER, STARTING_VALUE);
    }

    function testInteractionsUserCanFund() public {
        FundFundMe ffm = new FundFundMe();
        ffm.fund(address(fundMe));

        WithdrawFundMe wfm = new WithdrawFundMe();
        wfm.withdraw(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
