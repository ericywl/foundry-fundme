// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {DeploySimpleStorage} from "../../script/DeploySimpleStorage.s.sol";

contract SimpleStorageTest is Test {
    SimpleStorage simpleStorage;

    function setUp() external {
        DeploySimpleStorage deploySimpleStorage = new DeploySimpleStorage();
        simpleStorage = deploySimpleStorage.run();
    }

    function testCanStoreAndRetrive() public {
        uint256 storedNum = 123;
        simpleStorage.store(storedNum);

        uint256 retrievedNum = simpleStorage.retrieve();
        assertEq(storedNum, retrievedNum);
    }

    function testCanAddPerson() public {
        uint256 storedNum = 9524;
        string memory name = "Tester";

        simpleStorage.addPerson(name, storedNum);

        uint256 getNum = simpleStorage.getFavouriteNumberForPerson(name);
        assertEq(storedNum, getNum);
    }
}
