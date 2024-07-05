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

    // testBuyTime_simple
    function testBuyTime_simple() public {
        vm.startPrank(buyer1);

        // testBuyTime_eventsCorrect
        vm.expectEmit(false, false, false, true);
        emit BuyTimeEvent(address(buyer1), 0.05 ether, 0);
        vm.expectEmit(false, false, false, true);
        emit NewMemo(address(buyer1), block.timestamp, 1, message);

        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, message);

        vm.stopPrank();

        // nftId owned by buyer1

        assertEq(buyMyTime.ownerOf(0), buyer1);

        // testBuyTime_memoAccurate
        assertEq(buyMyTime.getMemos(0, 10).length, 1);
        Memo memory memo = buyMyTime.getMemos(0, 10)[0];
        assertEq(memo.message, message);
    }

    // testBuyTime_multipleTimeSlots
    function testBuyTime_multipleTimeSlots() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.25 ether}(5, message);
        vm.stopPrank();

        assertEq(buyMyTime.ownerOf(0), buyer1);
        assertEq(buyMyTime.ownerOf(1), buyer1);
        assertEq(buyMyTime.ownerOf(2), buyer1);
        assertEq(buyMyTime.ownerOf(3), buyer1);
        assertEq(buyMyTime.ownerOf(4), buyer1);
    }

    // testBuyTime_revert_insufficientFunds
    function testBuyTime_revert_insufficientFunds() public {
        vm.startPrank(buyer1);

        vm.expectRevert();
        buyMyTime.buyTime{value: 0.04 ether}(numTimeSlots, message);

        vm.stopPrank();
    }

    // testBuyTime_revert_messageLengthExceedsLimit
    function testBuyTime_revert_messageLengthExceedsLimit() public {
        vm.expectRevert();
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1026));
        vm.stopPrank();
    }

    // testBuyTime_maximumMessageLength
    function testBuyTime_maximumMessageLength() public {
        vm.startPrank(buyer1);
        buyMyTime.buyTime{value: 0.05 ether}(numTimeSlots, generateLongString(1024));
        vm.stopPrank();
    }

    // function needed for tests above
    function generateLongString(uint256 len) public returns (string memory) {
        string memory baseString = "a";
        string memory longString = "";
        for (uint256 i = 0; i < len; i++) {
            longString = string(abi.encodePacked(longString, baseString));
        }
        return longString;
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
