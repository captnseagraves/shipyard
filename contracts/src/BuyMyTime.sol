// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title Struct for storing information about a purchased time slot
/// @notice This struct is used to keep track of memos left by users when they purchase time slots
/// @dev Memos are stored per purchase, not per time slot, hence the numTimeSlots param
struct Memo {
    /// @notice The number of time slots purchased
    uint256 numTimeSlots;
    /// @notice The message or memo left by the buyer
    string message;
    /// @notice The timestamp when the memo was created
    uint256 time;
    /// @notice The address of the user who created the memo
    address userAddress;
}

/// @title A contract for buying and redeeming time slots as NFTs
/// @author captnseagraves
/// @notice This contract allows users to buy time slots and redeem them later
contract BuyMyTime is Ownable, ERC721 {
    /// ***** STATE VARIABLES ***** ///

    /// @notice The nonce for the NFTs minted by this contract
    uint256 private nftIdNonce;

    /// @notice Address where funds will be sent upon time slot purchase
    /// @dev decouples contract ownership from funds recipient
    address payable public recipientAddress;

    /// @notice Price per time slot
    uint256 public price;

    /// @notice Array of memos left by buyers
    Memo[] public memos;

    /// ***** EVENTS ***** ///

    /// @notice Event emitted when a time slot is purchased
    event BuyTimeEvent(address indexed buyer, uint256 price, uint256 nftId);

    /// @notice Event emitted when a time slot is redeemed
    event RedeemTimeEvent(address nftOwner, uint256 nftId);

    /// @notice Event emitted when a new memo is added
    event NewMemo(address indexed userAddress, uint256 time, uint256 numTimeSlots, string message);

    /// ***** ERRORS ***** ///

    /// @notice Error thrown when the sent funds are insufficient
    error InsufficientFunds();

    /// @notice Error thrown when invalid arguments are provided
    error InvalidArguments(string message);

    /// @notice Error thrown when the caller is not the owner of the NFT
    error NotNftOwner();

    /// ***** CONSTRUCTOR ***** ///

    /// @notice Initializes the contract with predefined name and symbol for the NFT and sets the initial owner
    /// @param name Name of the NFT
    /// @param symbol Symbol of the NFT
    /// @param initialOwner Address of the initial owner
    constructor(string memory name, string memory symbol, address initialOwner)
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        // set the initial price of a time slot
        price = 0.05 ether;

        // set initial recipient address
        recipientAddress = payable(initialOwner);
    }

    /// ***** EXTERNAL WRTIE FUNCTIONS ***** ///

    /// @notice Allows users to buy time slots and leave a memo
    /// @dev Mints new NFTs and stores the memos
    /// @param numTimeSlots Number of time slots to purchase
    /// @param message A message or memo left by the buyer
    function buyTime(uint256 numTimeSlots, string calldata message) public payable {
        // revert if msg.value is insufficient to pay for time slots
        if (msg.value < price * numTimeSlots) {
            revert InsufficientFunds();
        }

        // revert if message exceeds ~1024 characters
        if (bytes(message).length > 1024) {
            revert InvalidArguments("Input parameter exceeds max length");
        }

        // send eth to recipient address
        (bool sent,) = recipientAddress.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        // Mint NFTs, send to buyer, and emit event
        for (uint256 i = 0; i < numTimeSlots; i++) {
            _safeMint(msg.sender, nftIdNonce);
            emit BuyTimeEvent(msg.sender, msg.value, nftIdNonce);
            nftIdNonce++;
        }

        // add memo to storage
        memos.push(Memo(numTimeSlots, message, block.timestamp, msg.sender));

        // emit new memo event
        emit NewMemo(msg.sender, block.timestamp, numTimeSlots, message);
    }

    /// @notice Allows the owner of an NFT to redeem their time slot
    /// @param nftId The ID of the NFT to redeem
    function redeemTime(uint256 nftId) public {
        // check if msg.sender owns nftId
        if (_requireOwned(nftId) != msg.sender) {
            revert NotNftOwner();
        }

        // burn NFT
        _burn(nftId);

        // emit redeemTime event
        emit RedeemTimeEvent(msg.sender, nftId);
    }

    /// ***** EXTERNAL READ FUNCTIONS ***** ///

    /// @notice Retrieves a slice of the memos array
    /// @param index Index to start retrieving from
    /// @param size Number of memos to retrieve
    /// @return slice A slice of the memos array
    function getMemos(uint256 index, uint256 size) public view returns (Memo[] memory) {
        // if memos storage is empty return 0
        if (memos.length == 0) {
            return memos;
        }

        // revert if index provided is beyond storage length
        if (index >= memos.length) {
            revert InvalidArguments("Invalid index");
        }

        // revert if size is larger than 25
        if (size > 25) {
            revert InvalidArguments("size must be <= 25");
        }

        // temporaily store size
        uint256 effectiveSize = size;

        // adjust the size if it exceeds the array's bounds
        if (index + size > memos.length) {
            effectiveSize = memos.length - index;
        }

        // instantiate slice
        Memo[] memory slice = new Memo[](effectiveSize);

        // populate slice
        for (uint256 i = 0; i < effectiveSize; i++) {
            slice[i] = memos[index + i];
        }

        // return slice
        return slice;
    }

    /// ***** ADMIN WRITE FUNCTIONS ***** ///

    /// @notice Allows the owner to remove a memo
    /// @param index Index of the memo to remove
    function removeMemo(uint256 index) public onlyOwner {
        if (index >= memos.length) {
            revert InvalidArguments("Invalid index");
        }

        // instantiate memo from index
        Memo memory indexMemo = memos[index];
        // move last memo value to index to be deleted
        memos[index] = memos[memos.length - 1];
        // move memo value to be deleted to the last index
        memos[memos.length - 1] = indexMemo;
        // remove last index value
        memos.pop();
    }

    /// @notice Sets the price for a time slot
    /// @param _price New price for a time slot
    function setPriceForTimeSlot(uint256 _price) public onlyOwner {
        price = _price;
    }

    /// ***** SECURITY BEST PRACTICE FUNCTIONS ***** ///

    /// @notice Prevents the owner from renouncing ownership
    function renounceOwnership() public view override onlyOwner {
        revert("Ownership cannot be renounced");
    }

    /// @notice Reverts if the contract receives Ether with no data
    receive() external payable {
        revert("Contract cannot receive ETH");
    }

    /// @notice Reverts if the contract receives Ether with data or if no function matches the call
    fallback() external payable {
        revert("Contract cannot receive ETH");
    }
}
