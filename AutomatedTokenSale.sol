// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AutomatedTokenSale {
    address public owner;
    address public tokenAddress;
    uint256 public tokensToSellPerInterval;
    uint256 public saleInterval; // Time between sales in seconds
    uint256 public lastSaleTime;

    event TokensSold(address indexed buyer, uint256 amount);
    event SaleIntervalUpdated(uint256 newInterval);
    event TokensToSellUpdated(uint256 newAmount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(
        address _tokenAddress,
        uint256 _tokensToSellPerInterval,
        uint256 _saleInterval
    ) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        tokensToSellPerInterval = _tokensToSellPerInterval;
        saleInterval = _saleInterval;
        lastSaleTime = block.timestamp;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier nonReentrant() {
        require(!entered, "ReentrancyGuard: reentrant call");
        entered = true;
        _;
        entered = false;
    }

    bool private entered;

    function sellTokens(address buyer) public onlyOwner nonReentrant {
        require(
            block.timestamp >= lastSaleTime + saleInterval,
            "Sale interval not reached"
        );

        // Transfer tokens to the buyer
        IERC20(tokenAddress).transfer(buyer, tokensToSellPerInterval);
        lastSaleTime = block.timestamp;
        
        emit TokensSold(buyer, tokensToSellPerInterval);
    }

    function updateSaleInterval(uint256 newInterval) public onlyOwner {
        saleInterval = newInterval;
        emit SaleIntervalUpdated(newInterval);
    }

    function updateTokensToSell(uint256 newAmount) public onlyOwner {
        tokensToSellPerInterval = newAmount;
        emit TokensToSellUpdated(newAmount);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}
