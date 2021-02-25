pragma solidity 0.7.5;
pragma abicoder v2;

import "./Ownable.sol";

// todo
// modify ids - get transfers to properly be removed https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
// add some logging events
// test



contract Wallet is Ownable {
    
    mapping( address => uint ) balance;
    uint reqApprovalsForTransfer;
    
    uint transferCounter = 0;
    Transfer[] transferQueue;
    
    
    // constructor with up to 3 owners
    constructor(uint reqApprovals, address owner2, address owner3) {
        reqApprovalsForTransfer = reqApprovals;
        owners[owner2] = 1;
        owners[owner3] = 1;
    }
    
    struct Transfer {
        uint id;
        address from;
        address to;
        uint amount;
        uint numOfApprovals;
    }
    
    
    
    
    
    // adds balance to senders wallet
    function deposit () public payable {
        require(msg.value > 0, "You can only add positive amounts");
        
        uint prevBal = balance[msg.sender];
        balance[msg.sender] += msg.value;
        
        assert(balance[msg.sender] == prevBal + msg.value);
    }
    
    // sender can check their own balance
    function getBalance () public view returns (uint) {
        return balance[msg.sender];
    }
    
    // gets liqudity of all wallet holders
    function getLiquidity () public view returns (uint) {
        return address(this).balance;
    }
    
    function makeTransferRequest (address recipient, uint amount) public onlyOwner {
        require(balance[msg.sender] >= amount, "You cannot send more than you have");
        
        Transfer memory newTrans = Transfer(++transferCounter, msg.sender, recipient, amount, 0);
        
        // remove transfer amount from balance, so they cannot send more transfers than they can afford.
        balance[msg.sender] -= amount;
        
        uint queueLengthBefore = transferQueue.length;
        transferQueue.push(newTrans);
        
        assert(transferQueue.length == queueLengthBefore + 1);
    }
    
    function approveRequest (uint transferId) public onlyOwner {
        uint i = getListIdWithTransferId(transferId);
        transferQueue[i].numOfApprovals++;
        
        if ( transferQueue[i].numOfApprovals >= reqApprovalsForTransfer ) {
            _transfer(transferId);
        }
    }
    
    function _transfer (uint transferId) private {
        uint i = getListIdWithTransferId(transferId);
        balance[transferQueue[i].to] += transferQueue[i].amount;
        
        delete transferQueue[i];
    }
    
    function getListIdWithTransferId (uint id) private view returns (uint) {
        for ( uint i = 0; i < transferQueue.length; i++ ) {
            if (transferQueue[i].id == id) return i;
        }
    }
    
    
    
    // testing functions:
    function amIAnOwner () public view returns (bool) {
        return isOwner(msg.sender);
    }
    
    function getTransferCounter () public view returns (uint) {
        return transferCounter;
    }
    
    function getTransfers () public view returns (Transfer[] memory) {
        return transferQueue;
    }
    
    
}