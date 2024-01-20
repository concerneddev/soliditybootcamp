// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

// Inheriting the SimpleStorage contract
contract ExtraStorage is SimpleStorage{

    // Overriding the store() function
    // For this, we add "virtual" keyword in the original function ...
    // ... and add "override" keyword in the overriding function.
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}
