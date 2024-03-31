// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {BatchInbox} from "../src/BatchInbox.sol";

contract BatchInboxTest is Test {
    BatchInbox public batchInbox;

    function setUp() public {
        batchInbox = new BatchInbox(0x804C520d3c084C805E37A35E90057Ac32831F96f);
    }

    function testDepositWithdrawOK() public {
        // Give the test contract some ether
        vm.deal(address(this), 1000 ether);

        // deposit 1 ether for target
        address target = address(111);
        uint256 amount = 1 ether;
        uint256 balanceBefore = target.balance;
        assertEq(batchInbox.balances(target), 0);
        batchInbox.deposit{value: amount}(target);
        assertEq(batchInbox.balances(target), amount);

        // withdraw 1 ether from target, to target
        vm.prank(target);
        batchInbox.withdraw(target, amount);
        uint256 balanceAfter = target.balance;

        assertEq(balanceBefore + amount, balanceAfter);
    }

    function testDepositWithdrawNG() public {
        // Give the test contract some ether
        vm.deal(address(this), 1000 ether);

        // deposit 1 ether for target
        address target = address(111);
        uint256 amount = 1 ether;
        assertEq(batchInbox.balances(target), 0);
        batchInbox.deposit{value: amount}(target);
        assertEq(batchInbox.balances(target), amount);

        // withdraw 2 ether from target, to target
        vm.prank(target);
        vm.expectRevert(BatchInbox.BalanceNotEnough.selector);
        batchInbox.withdraw(target, 2 ether);
    }
}
