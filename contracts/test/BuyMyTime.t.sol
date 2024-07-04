// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {BuyMyTime, Memo} from "../src/BuyMyTime.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract BuyMyTimeTest is Test {
    BuyMyTime public buyMyTime;
    uint256 numTimeSlots = 1;
    string message = "message";
    address owner = 0x5Ad3b55625553CEf54D7561cD256658537d54AAd;
    address buyer1 = vm.addr(0x2);

        event BuyTimeEvent(address indexed buyer, uint256 price, uint256 nftId);
    event RedeemTimeEvent(address nftOwner, uint256 nftId);
    event NewMemo(address indexed userAddress, uint256 time, uint256 numTimeSlots, string message);


    function setUp() public {
        buyMyTime = new BuyMyTime("test", "TEST", owner);

        // fund buyer wallet
        payable(buyer1).transfer(1000 ether);
    }

    // testBuyTime_simple
        // nftId owned by buyer1
    function testBuyTime_simple() public {

        vm.startPrank(buyer1);
        
        vm.expectEmit(false, false, false, true);
        emit BuyTimeEvent(address(buyer1), 0.05 ether, 0);

        vm.expectEmit(false, false, false, true);
        emit NewMemo(address(buyer1), block.timestamp, 1, message);

        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);

        vm.stopPrank();

        assertEq(buyMyTime.ownerOf(0), buyer1);

        assertEq(buyMyTime.getMemos(0, 10).length, 1);
        Memo memory memo = buyMyTime.getMemos(0, 10)[0];
        assertEq(memo.message, message);
    }
    // testBuyTime_multipletimeSlots
        // nftId owned by buyer1
    // testBuyTime_revert_insufficientFunds
    // testBuyTime_revert_messageLengthExceedsLimit
    // testBuyTime_memoAccurate
    // testBuyTime_eventCorrect

    // testRedeemTime_simple
        // nftId not owned by buyer1
    // testRedeemTime_revert_notNftOwner
    // testRedeemTime_eventCorrect



    // testGetMemos_return0EmptyArray
    // testGetMemos_revert_indexBeyondStorageLength
    // testGetMemos_revert_sizeLargerThan25

    // testRemoveMemo_simple
    // testRemoveMemo_revert_notOwner

    // testsetPriceForTimeSlot_simple
    // testsetPriceForTimeSlot_revert_notOwner

    // testRenounceOwnership_revert_ownershipCannotBeRenounced








    

    function testRemoveMemo() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        vm.stopPrank();
        assertEq(buyMyTime.getMemos(0, 10).length, 1);

        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, "testMessage");
        vm.stopPrank();

        vm.startPrank(owner);
        buyMyTime.removeMemo(0);
        vm.stopPrank();
        assertEq(buyMyTime.getMemos(0, 10)[0].message, "testMessage");
    }

    function testPaging() public {
        uint256 amtToAdd = 100;
        for (uint256 i = 0; i < amtToAdd; i++) {
            vm.startPrank(buyer1);
            buyMyTime.buyTime{value: 0.05 ether}(1, Strings.toString(i));
            vm.stopPrank();
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
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1026));
        vm.stopPrank();
    }

    function testMaxMemoAllSizesAtMaximumShouldAccept() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1024));
        vm.stopPrank();
    }

    function testEmptyMemoNoError() public {
        Memo[] memory memos = buyMyTime.getMemos(15, 0);
        assertEq(memos.length, 0);
    }

    function testInvalidIndexErrors() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        vm.stopPrank();

        vm.expectRevert();
        Memo[] memory memos = buyMyTime.getMemos(15, 10);
    }

    function testSetPriceForTimeSlot() public {
        vm.startPrank(owner);
        buyMyTime.setPriceForTimeSlot(1 ether);
        vm.stopPrank();

        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 1 ether}(numTimeSlots, message);
        vm.stopPrank();
        assertEq(buyMyTime.getMemos(0, 10).length, 1);
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
