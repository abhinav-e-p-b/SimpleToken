// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleToken
 * @dev A basic ERC-20 style token contract demonstrating Solidity fundamentals
 */
contract SimpleToken {
    // State variables
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    
    // Mapping to store balances
    mapping(address => uint256) public balanceOf;
    
    // Mapping for allowances (for approve/transferFrom functionality)
    mapping(address => mapping(address => uint256)) public allowance;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier validAddress(address _address) {
        require(_address != address(0), "Invalid address");
        _;
    }
    
    /**
     * @dev Constructor - initializes the token
     * @param _name Token name
     * @param _symbol Token symbol
     * @param _decimals Number of decimals
     * @param _initialSupply Initial token supply
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**_decimals;
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        
        emit Transfer(address(0), owner, totalSupply);
    }
    
    /**
     * @dev Transfer tokens from sender to recipient
     * @param _to Recipient address
     * @param _value Amount to transfer
     * @return success True if transfer successful
     */
    function transfer(address _to, uint256 _value) 
        public 
        validAddress(_to) 
        returns (bool success) 
    {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    /**
     * @dev Approve spender to spend tokens on behalf of owner
     * @param _spender Address authorized to spend
     * @param _value Amount authorized to spend
     * @return success True if approval successful
     */
    function approve(address _spender, uint256 _value) 
        public 
        validAddress(_spender) 
        returns (bool success) 
    {
        allowance[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * @dev Transfer tokens from one address to another using allowance
     * @param _from Address to transfer from
     * @param _to Address to transfer to
     * @param _value Amount to transfer
     * @return success True if transfer successful
     */
    function transferFrom(address _from, address _to, uint256 _value) 
        public 
        validAddress(_from) 
        validAddress(_to) 
        returns (bool success) 
    {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    /**
     * @dev Mint new tokens (only owner)
     * @param _to Address to mint tokens to
     * @param _value Amount to mint
     */
    function mint(address _to, uint256 _value) 
        public 
        onlyOwner 
        validAddress(_to) 
    {
        totalSupply += _value;
        balanceOf[_to] += _value;
        
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
    }
    
    /**
     * @dev Burn tokens from sender's balance
     * @param _value Amount to burn
     */
    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
    }
    
    /**
     * @dev Transfer ownership to a new owner (only current owner)
     * @param _newOwner Address of the new owner
     */
    function transferOwnership(address _newOwner) 
        public 
        onlyOwner 
        validAddress(_newOwner) 
    {
        owner = _newOwner;
    }
    
    /**
     * @dev Get the balance of an address
     * @param _owner Address to check balance for
     * @return balance Token balance
     */
    function getBalance(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }
    
    /**
     * @dev Get token information
     * @return Token name, symbol, decimals, and total supply
     */
    function getTokenInfo() public view returns (
        string memory,
        string memory,
        uint8,
        uint256
    ) {
        return (name, symbol, decimals, totalSupply);
    }
}
