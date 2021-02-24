pragma solidity 0.7.5;

import "./Ownable.sol";


interface GovInterface {
    function addTransaction (address from, address to, uint amount) external;
}

contract Bank is Ownable {
    
    GovInterface governmentInstance = GovInterface(0x9ecEA68DE55F316B702f27eE389D10C2EE0dde84);
    
    event depositComplete(uint amount, address indexed depositedTo);
    event withdrawComplete(uint amount, address withdrawnTo);
    event transferComplete(uint amount, address from, address to);
    event balanceAdded(uint amount, address account);
    
    mapping( address => uint) balance;
    
    function addBalance(uint _toAdd) public onlyOwner returns (uint) {
        require(msg.sender == owner, "Only the contract owner can add balances");
        emit balanceAdded(_toAdd, msg.sender);
        return balance[msg.sender] += _toAdd;
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
    
    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, 'Balance insufficient'); // check balance of sender
        require(msg.sender != recipient, "You cannot transfer to yourself"); // cannot send to yourself
        
        uint prevSenderBalance = balance[msg.sender];
        _transfer(msg.sender, recipient, amount);
        
        governmentInstance.addTransaction(msg.sender, recipient, amount);
        
        assert(balance[msg.sender] == prevSenderBalance - amount);
        emit transferComplete(amount, msg.sender, recipient);
        
    }
    
    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
}