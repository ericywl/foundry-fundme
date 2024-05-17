// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint256 s_favoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] s_people;
    mapping(string => uint256) public s_nameToFavoriteNumber;

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        s_people.push(Person({favoriteNumber: _favoriteNumber, name: _name}));
        s_nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    function store(uint256 _favoriteNumber) public {
        s_favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return s_favoriteNumber;
    }

    function getFavouriteNumberForPerson(
        string memory _name
    ) public view returns (uint256) {
        return s_nameToFavoriteNumber[_name];
    }
}
