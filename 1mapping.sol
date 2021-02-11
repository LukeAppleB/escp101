pragma solidity 0.8.1;

contract Mapping {
    
    mapping( address => uint) balance;
    
    
    function addBalance(uint _toAdd) public returns (uint) {
        return balance[msg.sender] += _toAdd;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
}