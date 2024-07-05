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

    // testRedeemTime_simple
    function testRedeemTime_simple() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(1, message);

        // testRedeemTime_eventCorrect
        vm.expectEmit(false, false, false, true);
        emit RedeemTimeEvent(address(buyer1), 0);

        buyMyTime.redeemTime(0);

        vm.stopPrank();

        // should revert with nonexistent token
        vm.expectRevert();
        buyMyTime.ownerOf(0);
    }

    // testRedeemTime_revert_notNftOwner
    function testRedeemTime_revert_notNftOwner() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(1, message);
        vm.stopPrank();

        vm.startPrank(buyer2);
        vm.expectRevert();
        buyMyTime.redeemTime(0);
        vm.stopPrank();
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
