pragma solidity 0.8.1;

contract Bank {
    
    mapping( address => uint) balance;
    
    
    function addBalance(uint _toAdd) public returns (uint) {
        return balance[msg.sender] += _toAdd;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    
    function transfer(address recipient, uint amount) public {
        // check balance of sender
        
        _transfer(msg.sender, recipient, amount);
        
        // logs and further checks
        
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
}