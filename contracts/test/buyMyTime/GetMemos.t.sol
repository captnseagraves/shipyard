// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {BuyMyTime, Memo} from "../../src/BuyMyTime.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract BuyMyTimeTest is Test {
    BuyMyTime public buyMyTime;
    uint256 numTimeSlots = 1;
    string message = "message";
    address owner = vm.addr(0x1);
    address buyer1 = vm.addr(0x2);
    address buyer2 = vm.addr(0x3);

    event BuyTimeEvent(address indexed buyer, uint256 price, uint256 nftId);
    event RedeemTimeEvent(address nftOwner, uint256 nftId);
    event NewMemo(address indexed userAddress, uint256 time, uint256 numTimeSlots, string message);

    function setUp() public {
        buyMyTime = new BuyMyTime("test", "TEST", owner);

        // fund buyer wallet
        payable(buyer1).transfer(1000 ether);
    }

    // testGetMemos_return0EmptyArray
    function testGetMemos_return0EmptyArray() public view {
        Memo[] memory memos = buyMyTime.getMemos(15, 0);
        assertEq(memos.length, 0);
    }

    // testGetMemos_revert_indexBeyondStorageLength
    function testGetMemos_revert_indexBeyondStorageLength() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        vm.stopPrank();

        vm.expectRevert();
        buyMyTime.getMemos(15, 10);
    }

    // testGetMemos_revert_sizeLargerThan25
    function testGetMemos_revert_sizeLargerThan25() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);
        vm.stopPrank();

        vm.expectRevert();
        buyMyTime.getMemos(15, 26);
    }

    // testGetMemos_paging
    function testGetMemos_paging() public {
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

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
