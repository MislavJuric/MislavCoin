/*
  This is my first attempt at implementing ERC-20 from scratch.
  I got stuck at implementing allowances in the transferFrom method
  (see the TODO there), so then I decided to look at other people's
  implementations. What bothered me in the ERC-20 specification is that
  I didn't understand what the transferFrom method was supposed to do
  from the ERC-20 specification. I thought it was supposed to send
  tokens from sender to receiver using one or multiple allowances
  that were given to the sender. In the end it turned out that
  the method is supposed to be looking at the allowance
  which the sender gave to the address submitting the transaction.

  
*/

pragma solidity >=0.4.17; // from https://eips.ethereum.org/EIPS/eip-20

contract MislavCoinv1 {

  mapping(address => uint256) balances; // stores balances of all token holders
  mapping(address => mapping(address => uint256)) allowances; // stores allowances of all token holders

  // events as defined by the ERC-20 standard
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  // contract variables
  address owner;
  uint256 unassignedTokens = 21000000; // inspired by the total number of Bitcoins

  // constructor which gives 50% of the token to the contract owner (deployer)
  constructor() public
  {
    owner = msg.sender;
    // give the owner 50% of the tokens
    balances[owner] += (unassignedTokens / 2);
    unassignedTokens -= (unassignedTokens / 2);
  }

  function issue(address _to, uint256 _value) public returns (bool success)
  {
    if (msg.sender != owner) // only the owner can issue tokens
    {
      return false; // TODO: maybe throw an exception here
    }
    if (unassignedTokens < _value)
    {
      return false; // TODO: maybe throw an exception here?
    }
    balances[_to] += _value;
    unassignedTokens -= _value;
  }

  function name() public view returns (string memory)
  {
    return "MislavCoin";
  }

  function symbol() public view returns (string memory)
  {
    return "MISLAV";
  }

  function decimals() public view returns (uint8)
  {
    return 18; // 18 decimals, like wei
  }

  function totalSupply() public view returns (uint256)
  {
    return 21000000;
  }

  function balanceOf(address _owner) public view returns (uint256 balance)
  {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success)
  {
    if (balances[msg.sender] < _value)
    {
      return false; // TODO: I should throw an expection here
    }
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value); // I must do this according to the specification
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
  {
    if ((_from != msg.sender) || (_from != owner)) // only the owner of the token or the token creator can send tokens
    {
      return false;
    }
    // TODO: Now I'd have to check if balances[_from] < _value
    // but I'd also have to check if allowances[_from] has any allowances and
    // if it does, then I'd either have to spend a fraction of one allowance
    // or aggregate multiple allowances from multiple different addresses
    // in order to transfer the tokens. Since I can't iterate over allowances
    // mapping, I don't know how to implement this.
    // I'll look into existing implementations, since I could use some help
    // now.
    balances[_from] -= _value;
    balances[_to] += _value;
    allowances[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool success)
  {
    // TODO: Check that balances[msg.sender] >= _value ?
    allowances[_spender][msg.sender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256 remaining)
  {
    return allowances[_spender][_owner];
  }

}
