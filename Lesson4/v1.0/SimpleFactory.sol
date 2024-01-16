//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract SimpleFactory{
    SimpleStorage[] public simpleStorageArray;

    //this creates SimpleStorage contract and the addresses to simpleStorageArray
    function createSimpleStorageContract() public{
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }


    //In order to interact with created SimpleStorage contracts, we provide index and for example store value there
    //sfStore --- stands for simple Factory store
    //In order to interact with the contract we need two things:
    //1. Address of the contract
    //2. ABI---Application Binary Interface: this shows all the functions and variables to interact with contract
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        //By importing "./SimpleStorage.sol", we have access to the ABI of the contract
        //Even though simpleStorageArray stores mainly the addresses of the contracts, since we have
        //access to the ABI, we do not need to wrap address like this: SimpleStorage(simpleStorageArray[_simpleStorageIndex])
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
    }

    //In order to access the value inside the SimpleStorage contract, we need to write new function.
    //sfStore does just write to the contract and do not give us access to get value from the contract
    //sfGet solves that(stands for simple factory get function)
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
    }

    
}

