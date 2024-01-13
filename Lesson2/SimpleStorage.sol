//SPDX-License-Identifier: MIT
//above makes licesing and sahring code easier 

//pragma solidity 0.8.7 :  here we have to write which version of solidity we use and here we selected exact version and then commented it
//pragma solidity ^0.8.7 : above 0.8.7
//pargma solidity >=0.8.7 <0.9.0 : in this range

pragma solidity 0.8.8;


//below are contract----it is kind of like class in  oject-oriented languages
contract SimpleStorage{
    uint256 favoriteNumber = 5;
    
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    //in solidity variables inside object is like element of array. below at index 0, there is favoriteNumber and at index 1 is name
    struct Person{
        uint256 favoriteNumber;
        string name;
    }

    //mapping type
    mapping(string => uint256) public nameToFavoriteNumber;

    Person[] public people;
    //Person public newPerson = Person({favoriteNumber:5, name:"makishima"});


    //view disallows function to change the state of the block but allows to get the value
    //pure disallows both change and reading
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }


    //calldata: temporary data, but cannot be modified
    //memory: temporary data, can be modified
    //storage: can be modified but not temporary. for example people is stored in "storage" 
    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }


}
