// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample{
    uint256 public result;

    //If we sent some native currency without calling any function in the contract, 
    //specail function recieve() will be called. It have to be external and payable, and it does not return any value
    receive() external payable { 
        result =1;
    }

    //If we sent data alongside with some native currency(or without it), special function fallback() will be called.
    //fallback() is also have to be external and payable, and do not return any value
    fallback() external payable {
        result=2;
     }
    
}