pragma solidity 0.7.5;

contract Ownable {
    address internal owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  //run calling function
    }
    
    constructor() {
        owner = msg.sender; // will be the person who deploys the contract
    }
}