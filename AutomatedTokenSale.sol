// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AutomatedTokenSale {
    address public owner;
    address public tokenAddress;
    uint256 public tokensToSellPerInterval;
    uint256 public saleInterval; // Time between sales in seconds
    uint256 public lastSaleTime;

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

    function sellTokens(address buyer) public onlyOwner {
        require(
            block.timestamp >= lastSaleTime + saleInterval,
            "Sale interval not reached"
        );

        // Transfer tokens to the buyer
        IERC20(tokenAddress).transfer(buyer, tokensToSellPerInterval);
        lastSaleTime = block.timestamp;
    }

    function updateSaleInterval(uint256 newInterval) public onlyOwner {
        saleInterval = newInterval;
    }

    function updateTokensToSell(uint256 newAmount) public onlyOwner {
        tokensToSellPerInterval = newAmount;
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}
