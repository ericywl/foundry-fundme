// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "contracts/SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpStores;

    // Create SimpleStorage contract and store in array.
    function createSimpleStorageContract() public {
        SimpleStorage simpStore = new SimpleStorage();
        simpStores.push(simpStore);
    }

    // Store number in SimpleStorage specified by index.
    function store(uint256 _index, uint256 _number) public {
        return SimpleStorage(address(simpStores[_index])).store(_number);
    }

    // Retrieve number from SimpleStorage specified by index.
    function retrieve(uint256 _index) public view returns (uint256) {
        return SimpleStorage(address(simpStores[_index])).retrieve();
    }
}
