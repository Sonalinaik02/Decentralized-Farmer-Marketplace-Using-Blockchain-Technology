// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FarmerMarketplace {
    struct Product {
        uint id;
        string name;
        uint priceInINR;
        uint quantity;
        address payable farmer;
        bool isSold;
    }

    uint public productCount;
    mapping(uint => Product) public products;
    AggregatorV3Interface internal priceFeed;

    event ProductListed(uint id, string name, uint priceInINR, uint quantity, address farmer);
    event ProductPurchased(uint id, address buyer);

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function listProduct(string memory _name, uint _priceInINR, uint _quantity) public {
        require(_priceInINR > 0, "Price must be > 0");
        require(_quantity > 0, "Quantity must be > 0");

        productCount++;
        products[productCount] = Product(productCount, _name, _priceInINR, _quantity, payable(msg.sender), false);

        emit ProductListed(productCount, _name, _priceInINR, _quantity, msg.sender);
    }

    function getLatestMaticInInr() public view returns (uint) {
        (, int price, , ,) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price");
        return uint(price);
    }

    function purchaseProduct(uint _id) public payable {
        Product storage product = products[_id];
        require(product.id > 0 && product.id <= productCount, "Invalid product");
        require(product.isSold == false, "Already sold");
        require(product.quantity > 0, "Out of stock");

        uint maticPriceInInr = getLatestMaticInInr();
        uint requiredMatic = (product.priceInINR * 1e8) / maticPriceInInr; // 8 decimals

        require(msg.value >= requiredMatic, "Insufficient MATIC sent");

        product.farmer.transfer(msg.value);
        product.quantity -= 1;
        if (product.quantity == 0) {
            product.isSold = true;
        }

        emit ProductPurchased(_id, msg.sender);
    }
}
