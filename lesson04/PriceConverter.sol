// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1 * 10 ** 18; 
    // "constant" saves gas
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // Setting the owner of the contract
    address public immutable i_owner; 
    // "immutable" saves gas; 
    // i_owner is convention for writing immutable var
    constructor(){
        i_owner = msg.sender;
    }

    // Sending funds to the contract
    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didnt send enough!"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
        // (1)
    }

    // Withdrawing the funds
    function withdraw() public onlyOwner{
        // Setting the value at the funderIndex equals to zero
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // (2)

        // Resetting the array
        funders = new address[](0);
        // (3)

        // Transferring ETH
        /*
        // Method 01: transfer
        payable(msg.sender).transfer(address(this).balance);

        // Method 02: send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed!");

        */
        // Method 03: call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!");
        // (4)
    }

    // Setting the modifier
    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender not owner!");
        if(msg.sender != i_owner) { revert NotOwner();} // New and Gas efficient.
        _;
    }
    // (5)
    
    // (6)
    receive() external payable {
        fund();
    }

    fallback() external payable { 
        fund();
    }
}

/*
NOTES:

(1)
The requirement is that the value sent must be greater than 1 ether ...
... or 1e18 === 1 * 10 * 18 === 10000000000000000000
"payable" keyword makes this function capable of sending value through it.
"Didnt send enough!" is the reverting message. 
This will occur if the value sent didnt fulfill the requirement. 
If the function reverts, the gas cost for its execution is sent back.
It accepts the amount and then pushes the sender address into the funders array.
Then, it maps the address to the value and store it in the addressToAmountFunded array.

After the library import, we are using the functions defined in the library.
Syntax for using the library functions:
IN LIBRARY:
function name(type variable1, type variable2){}

IN CONTRACT:
value01.name(value02)

(2)
We are iterating through the funders array and resetting the setting the value ...
... to zero.

(3)
We are resetting the array by starting with '0' elements.
Syntax: arrayName = new arrayType[](numberOfInitialElements);

(4) 
We can transfer the funds from contract in three ways.
Before transferring, we have convert the msg.sender using payable keyword
Before: msg.send --> this is of type "address"
After: payable(msg.send) --> this is of type "payable address"
This is required in order to transfer the balance.

transfer() method:
This method has a specific Gas cap. If it costs more Gas, it will revert and show error.

send() method:
This method has a specific Gas cap aswell. But this wont revert if the amount is more.
Instead, it returns a boolean value of the operation. We store that value and manually revert.

call() method:
This method is not specifically used for transfer, but we use this here to transfer the balance.
This method returns two variables: a boolean value, and data
Here, we omit the multiple return values as we did earlier by leaving the blank commas.
Also, we leave "" like in order to not return the 2nd value. 
Also, we similarly use the manually revert using require keyword.

Using call() method is the recommended way.

(5)
We are defining the modifier
When we apply the defined modifier to any function, it will checked the defined code first...
... with the instructions inside the modifier.
Inside the modifier instructions,
require(.... ); this is to check if the sender which called withdraw() function is the owner or not
-; this is to set that after the first line is ran ( require() ), do the rest of the code inside the withdraw() function

We could have done the reverse too; i.e setting the " -; " first then the "require()" line.
It would have performed the code inside the withdraw() function first then would have performed require().

(6)
If someone sends money to this contract without using the fund() function, we revert them back to the fund().
In this way, our minimum requirement is also fulfilled.
*/
