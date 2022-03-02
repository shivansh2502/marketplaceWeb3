pragma solidity ^0.5.0;

contract Marketplace{
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "MarketPlace";
    }

    function createProduct(string memory _name, uint _price) public {
        // Parameters should be correct
        // Require valid name
        require(bytes(_name).length >0);
        // Require valid price
        require(_price>0);

        // Increment Product Count
        productCount ++;
        // Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger an event
        emit ProductCreated(products[productCount].id, products[productCount].name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner 
        address payable _seller = _product.owner;
        
        // Make sure the product has valid id
        require(_id > 0 && _id <= productCount);
        // Enough ether in txn
        require(msg.value >= _product.price);
        // Require has product is already not purchased
        require(!_product.purchased);
        // Require buyer is not the seller
        require(_seller != msg.sender);

        // Transfer ownership to the buyer
        _product.owner = msg.sender;
        // Mark as purchased
        _product.purchased = true;
        // Update the product
        products[_id] = _product;
        // Pay the seller by sending them ether
        address(_seller).transfer(msg.value);

        // Trigger event
        emit ProductPurchased(_id, _product.name, _product.price, msg.sender, true);
        
    }

}
