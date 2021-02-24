pragma solidity 0.7.5;

import "./Ownable.sol";
import "./DoomsDayDevice.sol";

contract DoomsDayDevice is Ownable, DoomsDayDevice {
    
    
    
}

// Ownable.sol
contract Ownable {
    address owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  //run calling function
    }
    
    constructor() {
        owner = msg.sender; // will be the person who deploys the contract
    }
}

// DoomsDayDevice.sol
contract DoomsDayDevice is Ownable {
    function redButton () public onlyOwner {
        selfdestruct(payable(owner));
    }
}