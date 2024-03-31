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

        address target = address(1);
        uint256 balanceBefore = target.balance;
        assertEq(batchInbox.balances(target), 0);
        batchInbox.deposit{value: 1 ether}(target);
        assertEq(batchInbox.balances(target), 1 ether);

        vm.prank(target);
        batchInbox.withdraw(target, 1 ether);
        uint256 balanceAfter = target.balance;

        assertEq(balanceBefore + 1 ether, balanceAfter);
    }
}
