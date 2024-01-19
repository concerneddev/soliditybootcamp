// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory{
    SimpleStorage[] public simpleStorageArray; 
    // This is the array of type SimpleStorage which stores addresess ...
    // ... to the instances of SimpleStorage smart contracts.

    // Creating different instances of SimpleStorage contract.
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage(); 
        // This is a new instance of the SimpleStorage smart contract.
        // Everytime a new instance is created, that is deployed on the chain.

        simpleStorageArray.push(simpleStorage);
        // We are storing a reference/address of the new instance in the array.
    }

    // Storing the favoriteNumber in a specific contract inside the array.
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        // We are creating the object of specific smart contract saved in the array.
        // We followed this approach because the array is the type of "smart contract" not "addresses".
        // Because of this the ABI is available to us.
        // alt way to do this if it was the "addresses" array: ...
        // ...SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageIndex]);

        //simpleStorage.store(_simpleStorageNumber);
        // We are using the function of the specific smart contract made above ...
        // ... stored at the specified index in the array.

        // simpler way to do the above:
        SimpleStorage(simpleStorageArray[_simpleStorageIndex]).store(_simpleStorageNumber);
    }

    // Retrieving the favoriteNumber from a specific contract inside the array.
    function sfGet(uint256 _simpleStorageIndex) public view  returns(uint256){
        // SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        // Creating instance of the specific contract from the array.

        // return simpleStorage.retrieve();
        // Using that contract's "retrieve()" function to get the favoriteNumber stored.

        // simpler way to do the above:
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }


}
