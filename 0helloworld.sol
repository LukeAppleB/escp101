pragma solidity 0.8.1;

contract HelloWorld {
    
    string message;
    int exampleNumber = 1;
    uint positiveNumber = 1;    //must be >=0
    address ethAddress;
    
    constructor(string memory _message) {
        message = _message;
    }
    
    
    // view gives function permission to read outside variables
    function hello() public view returns( string memory ) {
        return message;
    }
    
    // pure means the function can only run on its own, cannot change or view outside variables
    function hello2() public pure returns ( string memory ) {
        return "Hello World!";
    }
    
    function isNum10( int number ) public view returns ( string memory ) {
        // always defined in function:
        // address a = msg.sender; //senders address
        // uint b = msg.value; // amount of ether in the message
        
        
        
        // this is just a simple example, keep in mind everything is visible on a public blockchain
        if ( number == 10 ) {
            return message;
        } else {
            return "wrong number stupid";
        }
    }
    
    function isCorrectAddress() public view returns ( string memory ) {
        if ( msg.sender == 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 ) {
            return "Winner Winner";
        }
        
        return "Loser Woooser";
    }
    
    
    // loops, getters, setters, arrays,  are the same as JS
    // struct is blueprint of object
    
    
    
    
    // MAPPINGS:
    // - Key Value pairs
    // suntax:
    // mapping(keytype=>valuetype) name
    mapping ( address => uint ) balances;
    
    
    /*
        visibility:
        
        Public - visible to everyone
        
        Private - only visible from within the contract
        
        Internal - similar to private visibility level
                   AND contracts deriving from it ( contracts which inherit our contract )
        
        External - Only other contracts or services can execute 
        
        
    */
    
}