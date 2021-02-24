pragma solidity 0.7.5;

contract Government {
    
    struct Transaction {
        uint txId;
        address from;
        address to;
        uint amount;
    }
    
    Transaction[] transactions;
    
    function addTransaction (address from, address to, uint amount) external {
        Transaction memory t = Transaction(transactions.length, from, to, amount);
        transactions.push(t);
    }
    
    function getTransaction (uint index) public view returns (address, address, uint) {
        return (transactions[index].from, transactions[index].to, transactions[index].amount);
    }
    
}