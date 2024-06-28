// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title Memos
 * @dev Memo struct
 */
struct Memo {
    uint256 numTimeSlots;
    string message;
    uint256 time;
    address userAddress;
}

/**
 * @title BuyMyTime
 * @dev BuyMyTime contract to purchase an Time Slot NFT and Redeem that NFT for a link to my calendly
 */
contract BuyMyTime is Ownable, ERC721{
        /// @notice The nonce for the NFTs minted by this contract
    uint256 private nftIdNonce;

    // This enables us to decouple ownership from the recipient address
    address payable public recipientAddress;
    uint256 public price;
    Memo[] public memos;
    

    error InsufficientFunds();
    error InvalidArguments(string message);
    error NotNftOwner();

    event BuyMyTimeEvent(address indexed buyer, uint256 price);
    event RedeemTimeEvent(address nftOwner, uint256 nftId);
    event NewMemo(address indexed userAddress, uint256 time, uint256 numTimeSlots, string message);

    constructor() {
        owner = payable(msg.sender);
        price = 0.05 ether;
    }

    /**
     * WRITE FUNCTIONS *************
     */

    /**
     * @dev Function to buy a time slot
     * @param  message The message of the user
     * (Note: Using calldata for gas efficiency)
     */
    function buyMyTime(uint256 numTimeSlots, string calldata message) public payable {
        if (msg.value < price * numTimeSlots) {
            revert InsufficientFunds();
        }

        if (bytes(message).length == 0) {
            revert InvalidArguments("Invalid message");
        }

        if (bytes(message).length > 1024) {
            revert InvalidArguments("Input parameter exceeds max length");
        }

        (bool sent,) = recipientAddress.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        // Mint NFTs and send to buyer
        for (uint256 i = 0; i < numTimeSlots; i++) {
            _safeMint(msg.sender, nftIdNonce);
            emit BuyMyTimeEvent(msg.sender, msg.value, nftIdNonce);
            nftIdNonce++;
        } 

        memos.push(Memo(numTimeSlots, message, block.timestamp, msg.sender));

        emit NewMemo(msg.sender, block.timestamp, numTimeSlots, message);
    }

    function redeemTime(uint256 nftId) public {
        // check if msg.sender owns nftId
        if (_requireOwned(nftId) != msg.sender) {
            revert NotNftOwner();
        }

        // Burn NFT
        _burn(nftId);

        // Emit redeemTime event
        emit RedeemTimeEvent(msg.sender, nftId);
    }

    /**
     * @dev Function to remove a memo
     * @notice Only callable by owner
     * @param  index The index of the memo
     */
    function removeMemo(uint256 index) onlyOwner public {
        if (index >= memos.length) {
            revert InvalidArguments("Invalid index");
        }

        Memo memory indexMemo = memos[index];
        memos[index] = memos[memos.length - 1];
        memos[memos.length - 1] = indexMemo;
        memos.pop();
    }

    /**
     * @dev Function to get the price of a timeslot
     */
    function setPriceForTimeSlot(uint256 _price) onlyOwner public {
        price = _price;
    }

    /**
     * READ FUNCTIONS *************
     */

    /**
     * @dev Function to get the memos
     */
    function getMemos(uint256 index, uint256 size) public view returns (Memo[] memory) {
        if (memos.length == 0) {
            return memos;
        }

        if (index >= memos.length) {
            revert InvalidArguments("Invalid index");
        }

        if (size > 25) {
            revert InvalidArguments("size must be <= 25");
        }

        uint256 effectiveSize = size;
        if (index + size > memos.length) {
            // Adjust the size if it exceeds the array's bounds
            effectiveSize = memos.length - index;
        }

        Memo[] memory slice = new Memo[](effectiveSize);
        for (uint256 i = 0; i < effectiveSize; i++) {
            slice[i] = memos[index + i];
        }

        return slice;
    }

    /**
     * @dev Recieve function to accept ether
     */
    receive() external payable {}
}
