//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//We want ExtraStrorage to have all the fucntionality of the SimpleStorage.
//This concept is called INHERITENCE. ExtraStorage becomes child of the SimpleStorage

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage{
    //if we want ExtraStorage to behave a bit differently for a same function in the SimpleStorae,
    //we OVERRRIDE the function. For that, we need to tell the function here we override it, and tell 
    //the function in the SimpleStorage that is overridable.
    //Keywords for that are: override and virtual

    function store(uint256 _favoriteNumber) public override{
        //this function increments _favoriteNmber by 5(slightly different behavior)
        favoriteNumber = _favoriteNumber +5;
    }

}