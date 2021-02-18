pragma solidity 0.8.1;

contract Bank {
    
    mapping( address => uint) balance;
    address owner;
    
    
    constructor() {
        owner = msg.sender; // will be the person who deploys the contract
    }
    
    function addBalance(uint _toAdd) public returns (uint) {
        require(msg.sender == owner, "Only the contract owner can add balances");
        return balance[msg.sender] += _toAdd;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    
    function transfer(address recipient, uint amount) public {
        // check balance of sender
        require(balance[msg.sender] >= amount, 'Balance insufficient');
        
        // cannot send to yourself
        require(msg.sender != recipient, "You cannot transfer to yourself");
        
        uint prevSenderBalance = balance[msg.sender];
        
        
        _transfer(msg.sender, recipient, amount);
        
        
        assert(balance[msg.sender] == prevSenderBalance - amount);
        
        // logs and further checks
        
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
}