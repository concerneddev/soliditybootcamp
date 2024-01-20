// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Creating the PriceConverter library for handling the...
//... the math in FundMe.sol

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    // Getting the current price 
    function getPrice() internal  view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , ,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
        // (2)  
    }

    // Converting from ETH to USD
    function getConversionRate(uint ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd; 
    }
}

/*
NOTES:

(2)
We import the AggregatorV3 contract we are going to use from chainlink. 
We create an instance of that contract by passing the address of that....
... specific data feed on the Sepolia Testnet. 
We use the latestRoundDate() function present in that contract. 
We stor the price variable it returns and omit the other variables that it...
... originally returns by leaving the commas. 
We then finally remove the decimals as the contract originally doesnt return...
... answer upto specific decimal places.
**For removing the decimals, we use the conversion we know i.e. 10^18 Wei === 1 Ether
Finally, the function returns the current USD value of ETH and we typecast...
...it in uint256().

*/
