// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {BuyMyTime, Memo} from "../src/BuyMyTime.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BuyMyTimeTest is Test {
    BuyMyTime public buyMyTime;
    uint256 numTimeSlots = 1;
    string message = "message";
    address owner = 0x5Ad3b55625553CEf54D7561cD256658537d54AAd;

    function setUp() public {
        buyMyTime = new BuyMyTime("test", "TEST", owner);
    }

    function testGetMemos() public {
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        assertEq(buyMyTime.getMemos(0, 10).length, 1);
        Memo memory memo = buyMyTime.getMemos(0, 10)[0];
        assertEq(memo.message, message);
    }

    function testRemoveMemo() public {
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        assertEq(buyMyTime.getMemos(0, 10).length, 1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, "testMessage");
vm.startPrank(owner);
        buyMyTime.removeMemo(0);
        vm.stopPrank();
        assertEq(buyMyTime.getMemos(0, 10)[0].message, "testMessage");
    }

    function testPaging() public {
        uint256 amtToAdd = 100;
        for (uint256 i = 0; i < amtToAdd; i++) {
            buyMyTime.buyTime{value: 0.05 ether}(1, Strings.toString(i));
        }
        for (uint256 i = 0; i < amtToAdd; i++) {
            Memo[] memory memos = buyMyTime.getMemos(i, 1);
            assertEq(memos.length, 1);
        }
    }

    function generateLongString(uint256 len) public returns (string memory) {
        string memory baseString = "a";
        string memory longString = "";
        for (uint256 i = 0; i < len; i++) {
            longString = string(abi.encodePacked(longString, baseString));
        }
        return longString;
    }

    function testMaxMemoMessageSize() public {
        vm.expectRevert();
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1026));
    }

    function testMaxMemoAllSizesAtMaximumShouldAccept() public {
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1024));
    }

    function testEmptyMemoNoError() public {
        Memo[] memory memos = buyMyTime.getMemos(15, 0);
        assertEq(memos.length, 0);
    }

    function testInvalidIndexErrors() public {
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);

        vm.expectRevert();
        Memo[] memory memos = buyMyTime.getMemos(15, 10);
    }

    function testSetPriceForTimeSlot() public {
        buyMyTime.setPriceForTimeSlot(1 ether);
        buyMyTime.buyTime{value: 1 ether}(numTimeSlots, message);
        assertEq(buyMyTime.getMemos(0, 10).length, 1);
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
