pragma solidity 0.7.5;

contract Ownable {
    mapping ( address => uint ) internal owners;
    
    modifier onlyOwner {
        require(isOwner(msg.sender));
        _;  //run calling function
    }
    
    function isOwner (address adr) internal view returns (bool) {
        if ( owners[adr] == 1 ) {
            return true;
        }
        return false;
    }
        
    function addToOwnerList (address addrOfNewOwner) public onlyOwner {
        owners[addrOfNewOwner] = 1;
    }
    
    constructor() { // making list of owners a map vs an array for easier querying 
        owners[msg.sender] = 1; // will add the person who deploys the contract to owners list
    }
}