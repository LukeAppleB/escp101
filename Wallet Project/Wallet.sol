pragma solidity 0.7.5;
pragma abicoder v2;

import "./Ownable.sol";


contract Wallet is Ownable {
    
    mapping( address => uint ) balance;
    uint reqApprovalsForTransfer;
    
    uint transferCounter = 0;
    Transfer[] transferQueue;
    
    
    // constructor with 3 owners
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
    
    
    event transferRequestMade(Transfer newTrans);
    event transferApproved(Transfer approvedTrans, address approvedBy);
    event transferComplete(Transfer sentTrans);
    event depositComplete(address depositer, uint amount);
    
    
    // adds balance to senders wallet
    function deposit () public payable {
        require(msg.value > 0, "You can only add positive amounts");
        
        uint prevBal = balance[msg.sender];
        balance[msg.sender] += msg.value;
        
        assert(balance[msg.sender] == prevBal + msg.value);
        
        emit depositComplete(msg.sender, msg.value);
    }
    
    // sender can check their own balance
    function getBalance () public view returns (uint) {
        return balance[msg.sender];
    }
    
    function makeTransferRequest (address recipient, uint amount) public onlyOwner {
        require(balance[msg.sender] >= amount, "You cannot send more than you have");
        require(msg.sender != recipient, "You cannot send to yourself");
        
        Transfer memory newTrans = Transfer(++transferCounter, msg.sender, recipient, amount, 0);
        
        // remove transfer amount from balance, so they cannot send more transfers than they can afford.
        balance[msg.sender] -= amount;
        
        uint queueLengthBefore = transferQueue.length;
        transferQueue.push(newTrans);
        
        assert(transferQueue.length == queueLengthBefore + 1);
        emit transferRequestMade(newTrans);
    }
    
    function approveRequest (uint transferId) public onlyOwner {
        uint i = getListIdWithTransferId(transferId);
        transferQueue[i].numOfApprovals++;
        
        emit transferApproved(transferQueue[i], msg.sender);
        
        if ( transferQueue[i].numOfApprovals >= reqApprovalsForTransfer ) {
            _transfer(i);
        }
    }
    
    function _transfer (uint arrayIndex) private {
        emit transferComplete(transferQueue[arrayIndex]);
        
        balance[transferQueue[arrayIndex].to] += transferQueue[arrayIndex].amount;
        removeFromQueue(arrayIndex);
    }
    
    // https://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array
    function removeFromQueue(uint arrayIndex) private {
        if (arrayIndex >= transferQueue.length) return;

        for (uint i = arrayIndex; i < transferQueue.length-1; i++){
            transferQueue[i] = transferQueue[i+1];
        }
        transferQueue.pop();
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
    
    function getTransferQueueLength () public view returns (uint) {
        return transferQueue.length;
    }
    
    // gets liqudity of all wallet holders
    function getLiquidity () public view returns (uint) {
        return address(this).balance;
    }
    
    
}