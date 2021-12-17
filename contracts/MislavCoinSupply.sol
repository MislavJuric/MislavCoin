/*
    Adapted from from https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226
*/

pragma solidity ^0.8.0;

import "./MislavCoinv3.sol";

contract MislavCoinSupply is MislavCoinv3("MislavCoin", "MC") // MislavCoinv3 is ERC20
{
    constructor() public // gives 1000 * 1000000000000000000 tokens to the owner (1000 Ether's worth of tokens)
    {
        _mint(msg.sender, 1000 * 1000000000000000000); // 1000000000000000000 is 1 Ether in Wei; TODO: fix this magic number
    }

    function getCoinbase() public returns (address) // for debugging purposes
    {
        return block.coinbase;
    }

    function _mintMinerReward() internal // gives 20 tokens to the miner
    {
        // _mint(block.coinbase, 20); // for some reason, block.coinbase is address 0; TODO: uncomment this in production
    }

    function _transfer(address from, address to, uint256 value) override internal
    {
        _mintMinerReward();
        super._transfer(from, to, value);
    }
}
