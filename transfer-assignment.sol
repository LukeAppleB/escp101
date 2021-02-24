pragma solidity 0.7.5;

contract Bank {
    
    event depositComplete(uint amount, address indexed depositedTo);
    event withdrawComplete(uint amount, address withdrawnTo);
    
    mapping( address => uint) balance;
    address owner;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  // run the function - this will be replaced with the code from calling function
    }
    
    constructor() {
        owner = msg.sender; // will be the person who deploys the contract
    }
    
    function deposit() public payable returns (uint) {
        emit depositComplete(msg.value, msg.sender);
        balance[msg.sender] += msg.value;
        return balance[msg.sender];
    }
    
    function withdraw(uint amount) public returns (uint) {
        require(amount <= balance[msg.sender], "Cannot withdraw more than your balance!");
        
        uint prevBalance = balance[msg.sender];
        msg.sender.transfer(amount);
        balance[msg.sender] -= amount;
        
        assert(balance[msg.sender] == prevBalance - amount);
        emit withdrawComplete(amount, msg.sender);
        return balance[msg.sender];
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
}