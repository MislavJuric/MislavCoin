/*
    Adapted from https://ethereum.org/en/developers/tutorials/transfers-and-approval-of-erc-20-tokens-from-a-solidity-smart-contract/

    I didn't try to code my own DEX from scratch because I wasn't familiar with token to Ether conversion dynamics,
    so I thought a better idea would be to modify existing solutions.

    Another solution that I took a look at is here: https://programtheblockchain.com/posts/2018/02/02/writing-a-token-sale-contract/
*/

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./MislavCoinSupply.sol";

contract MislavCoinDEX
{
    IERC20 public token;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() public
    {
        token = new MislavCoinSupply();
    }

    function getSenderAddress() public view returns (address) // for debugging purposes
    {
        return (msg.sender);
    }

    function getAddress() public view returns (address)
    {
        return address(this);
    }

    function getTokenAddress() public view returns (address)
    {
        return address(token);
    }

    function buy() payable public // send Wei and get tokens in exchange; 1 token == 1 Wei
    {
      uint256 amountTobuy = msg.value;
      uint256 dexBalance = token.balanceOf(address(this));
      require(amountTobuy > 0, "You need to send some ether");
      require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
      token.transfer(msg.sender, amountTobuy);
      emit Bought(amountTobuy);
    }

    function sell(uint256 amount) public // send tokens to get Ether back; TODO: Sometimes this numerically overflows; fix it
    {
      require(amount > 0, "You need to sell at least some tokens");
      uint256 allowance = token.allowance(msg.sender, address(this));
      require(allowance >= amount, "Check the token allowance");
      token.transferFrom(msg.sender, address(this), amount);
      // https://stackoverflow.com/questions/67341914/error-send-and-transfer-are-only-available-for-objects-of-type-address-payable
      payable(msg.sender).transfer(amount);
      emit Sold(amount);
    }

}
