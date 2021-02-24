pragma solidity 0.8.1;

contract Bank {
    
    // events are a way to log data 
    // anyone can listen for events - like webhooks
    
    // make a sample event for when people addBalance
    //      indexed means that they can be searched by ethereum nodes
    //      can only have 3 indexed parameters per contract
    event balanceAdded(uint amount, address indexed depositedTo);
    event transferComplete(uint amount, address from, address to);
    
    mapping( address => uint) balance;
    address owner;
    
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  // run the function - this will be replaced with the code from calling function
    }
    
    constructor() {
        owner = msg.sender; // will be the person who deploys the contract
    }
    
    function addBalance(uint _toAdd) public onlyOwner returns (uint) {
        require(msg.sender == owner, "Only the contract owner can add balances");
        emit balanceAdded(_toAdd, msg.sender);
        return balance[msg.sender] += _toAdd;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, 'Balance insufficient'); // check balance of sender
        require(msg.sender != recipient, "You cannot transfer to yourself"); // cannot send to yourself
        
        uint prevSenderBalance = balance[msg.sender];
        
        _transfer(msg.sender, recipient, amount);
        
        // logs and further checks
        
        assert(balance[msg.sender] == prevSenderBalance - amount);
        
        emit transferComplete(amount, msg.sender, recipient);
        
        
        
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
}