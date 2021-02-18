pragma solidity 0.8.1;

contract DataLocation {
    
    
    // storage - permanent storage 
    
    // state variable - stored in storage
    uint data = 123;
    
    
    // memory - temporary storage -> function args and variables in functions
    
    
    // calldata - similar to memory but read only
    
    function getString (string memory text) public pure returns(string memory) {
        return text;
    }
    
}