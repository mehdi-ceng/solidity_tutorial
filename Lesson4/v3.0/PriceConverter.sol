//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//Libraries can't have state variables, they can't send ether
//All functions of library will be internal
library PriceConverter{
    //BELOW IS COPIED FROM THE FundMe.sol TO CREATE LIBRARY.
    //Functions are changed from public to internal
     
     //Inorder to set minumim as usd, we need the info from the outside world.
        //If we got our info from one source and intagrate that to the blockchain, then we introduce the system on point 
        //of failure, the one thing we tried get rid of using blockchain: central authority. Therefore, we need decentrailzed netwrok
        // and ChainLink is for that. It is for out-of-chain data and computation.
        //Chainlink Data Feeds helps to get USD/ETH value.

    function getPrice() internal view returns(uint256) {
        //Info for ETH/USD is also in contract. So we need address of the contract and ABI as well
        //Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI is AggregatorV3Interface

        //We created priceFeed object, type of AggregatorV3Interface
        //Then applied latesRoundData() method on it. In order to find about the methods and how to use them we have to look at 
        //documentations here: 
        //https://docs.chain.link/data-feeds/using-data-feeds  
        //https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        //answer ----  ETH in terms of USD
        //Also it is  8 decimal(we can learn it using decimal() method), something like  3000.00000000(but there is no dot in actual value that is hold in answer)
        //But msg.value is 18 decimal, since 1ETH is 1e18 wei and is type of uint256. In order to balance that we do followinf calculations
        return uint256(answer*1e10);

    }

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    //converts from ETH to USD
    //First argument below is get value of msg.value when used as msg.value.getConversion()
    //someMethod(type arg1, type arg2) ---> usage: var1.someMethod(var2) where arg1=var1 and arg2=var2
    function getConversion(uint256 ethAmount) internal view returns(uint256) {
         uint256 ethPrice = getPrice();
         uint256 amountInUsd = (ethPrice*ethAmount)/1e18; 
         // since both price and ethAmount has 18 decimal, we have to divide it by 1e18 to make amountInUsd in 18 decimal 

         return amountInUsd; 
    }

}
