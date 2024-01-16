//Get funds from the users
//Withdraw funds
//set minumut amount for funding in usd

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//The code snippet below is interface and can be got using this path in 
//the github/chainlink repository:  contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol
/*
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}
*/

//But we do not have to copy all the code here. We can import them from the github
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//Contracts and wallets are similar in a way that, you can have some eth in the contract too.
//For example they both have addresses.
contract FundMe{

    address[] public funders;
    mapping(address=> uint256) addressToAmountFunded;


     function fund() public payable{
        //People can fund. So make the function public and payable

        //Value in the value field of the contract or transaction can be accessed by msg.value.
        //require(msg.value >= 1e18, "Send little more, like 1 ETH"); 

        //Here we check values in terms of USD
        uint256 minUsd = 50*1e18; 
        //Above we actually say min usd amount is 50 dollar, but in order to compare it  with eth and getConversion()
        //we add 18 decimal

        require(getConversion(msg.value) >= minUsd, "Send little more, like 1 ETH"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
     }



        //Inorder to set minumim as usd, we need the info from the outside world.
        //If we got our info from one source and intagrate that to the blockchain, then we introduce the system on point 
        //of failure, the one thing we tried get rid of using blockchain: central authority. Therefore, we need decentrailzed netwrok
        // and ChainLink is for that. It is for out-of-chain data and computation.
        //Chainlink Data Feeds helps to get USD/ETH value.

    function getPrice() public view returns(uint256) {
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

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    //converts from ETH to USD
    function getConversion(uint256 ethAmount) public view returns(uint256) {
         uint256 ethPrice = getPrice();
         uint256 amountInUsd = (ethPrice*ethAmount)/1e18; 
         // since both price and ethAmount has 18 decimal, we have to divide it by 1e18 to make amountInUsd in 18 decimal 


         return amountInUsd; 
    }

     //function withdraw(){}
}