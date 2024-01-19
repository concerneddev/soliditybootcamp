// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage{
    // this get initialized to zero
    // public automatically makes it's "getter" function
    uint256 public favoriteNumber;

    // mapping
    // intializes to NULL or 0
    // here... key : value
    mapping (string => uint256) public nameToFavoriteNumber;


    struct People{
        uint256 favoriteNumber;
        string name;
    }
    // simple implementation of struct
    //People public person = People({favoriteNumber: 1, name: "Nimish"});

    // array-based struct implementation
    // !! you can use anything as an array !!
    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view, pure
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    // memory, calldata, storage
    // memory means that the variable defined only is valid for the function called
    // this variable exists temporarily..
    // storage means that the variable is valid even outside the function. 
    // we dont have to explicitly define them.
    // calldata means that we cannot modify that variable after assignment.
    // pushing into people struct array
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
