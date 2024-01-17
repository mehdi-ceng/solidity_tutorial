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

//The functions are transferred to PriceConverter.sol to create library there.
//Libary makes contract to be more computationally easy, by taking computations out of the contract.
//In order to access those function and use them here we need to import the file.
import "./PriceConverter.sol";


//Contracts and wallets are similar in a way that, you can have some eth in the contract too.
//For example they both have addresses.
contract FundMe{
    using PriceConverter for uint256;

    address[] public funders;
    mapping(address=> uint256) public addressToAmountFunded;

    //Just after deploying, we want owner to be the one deploys this contract
    address public owner;

    constructor(){
      owner = msg.sender;
    }

    function fund() public payable{
        //People can fund. So make the function public and payable

        
        //Value in the value field of the contract or transaction can be accessed by msg.value.
        //require(msg.value >= 1e18, "Send little more, like 1 ETH"); 

        //Here we check values in terms of USD
        uint256 minUsd = 50*1e18; 
        //Above we actually say min usd amount is 50 dollar, but in order to compare it  with eth and getConversion()
        //we add 18 decimal

        //Now get conversion is defined as method of uint256(by using library keyword in PriceConverter.sol file)
        //In that case usage is like that msg.value.getConversion()
        require(msg.value.getConversion() >= minUsd, "Send little more, like 1 ETH or 50 USD"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
     }
    

     function withdraw() public onlyOwner{
        //We need to empty the funders array and the amounts of eth is mapped to them. Then actully witdraw the amount in the contract
        
        //Reset amounts to the zero
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
          address funder = funders[funderIndex];
          addressToAmountFunded[funder] = 0;
        }

        //Reset funders array
        //We made funders array to be address array of zero element
        funders = new address[](0);

      //We need to actually withdraw money from the contract. There are 3 ways to do that
      //More in here: https://solidity-by-example.org/sending-ether/
       //1. Transfer
       //payable(msg.sender).transfer(address(this).balance);
       //2. Send
       //bool sendSuccess = payable (msg.sender).send(address(this).balance);
       //require(sendSuccess, "Withdraw failed");
       //3. Call
       (bool callSuccess, )=payable (msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call failed");
     }



     //We want only owner to be able to withdraw money
     modifier onlyOwner{
      require(owner == msg.sender, "You're not the owner");
      _;  //This is kind of the placeholder for the function body that is modified. After above line is executed then body of function will be executed
     }
}