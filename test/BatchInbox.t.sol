// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {BatchInbox} from "../src/BatchInbox.sol";

contract BatchInboxTest is Test {
    BatchInbox public batchInbox;

    function setUp() public {
        batchInbox = new BatchInbox(0x804C520d3c084C805E37A35E90057Ac32831F96f);
    }

    function test_Increment() public {
        
    }

}
