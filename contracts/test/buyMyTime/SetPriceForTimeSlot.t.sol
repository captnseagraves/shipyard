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

    // testsetPriceForTimeSlot_simple
    function testSetPriceForTimeSlot_simple() public {
        vm.startPrank(owner);
        buyMyTime.setPriceForTimeSlot(1 ether);
        vm.stopPrank();

        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 1 ether}(numTimeSlots, message);
        vm.stopPrank();

        vm.startPrank(buyer1);
        vm.expectRevert();
        buyMyTime.buyTime{value: 0.5 ether}(numTimeSlots, message);
        vm.stopPrank();
    }
    // testsetPriceForTimeSlot_revert_notOwner

    function testsetPriceForTimeSlot_revert_notOwner() public {
        vm.startPrank(buyer1);
        vm.expectRevert();
        buyMyTime.setPriceForTimeSlot(1 ether);
        vm.stopPrank();
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
