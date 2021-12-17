/*
    This is my first try at implementing a vesting schedule in a contract. I thought it was good enough, so I didn't iterate upon it.

    The vesting schedule will be:

    Release 25% over 4 years each (each year you get 25%, starting from when 1 year elapses)
*/

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./MislavCoinSupply.sol";

contract MislavCoinVestingv1
{
    IERC20 public token;
    address private owner;
    mapping(address => uint256) private amountsToRelease;
    mapping(address => uint256) private startingDates;
    mapping(address => bool[4]) private alreadyUsedPeriods;

    uint256 private VESTING_PERIOD = 4;
    uint256 private YEAR = 52 weeks; // approximately a year

    event Released(address beneficiary, uint256 amount);

    /// An error which is triggered if the minimum vesting period (in this case, a year)
    /// hasn't passed.
    error TriedToReleaseTooEarlyError();

    constructor() public
    {
        token = new MislavCoinSupply();
        owner = msg.sender;
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

    function addBeneficiary(address beneficiary, uint256 amount) public returns (bool)
    {
        require(msg.sender == owner, "Only the owner can add beneficiaries");
        token.approve(beneficiary, amount);
        amountsToRelease[beneficiary] = amount;
        startingDates[beneficiary] = block.timestamp;
        return true;
    }

    function releaseTokens() public returns (bool)
    {
        // check if there's any amount of tokens to release
        require(token.allowance(address(this), msg.sender) > 0, "There are no more funds left to release.");
        // check the time elapsed and based on it make a transfer
        uint256 amountToTransfer = uint256(amountsToRelease[msg.sender] / VESTING_PERIOD);
        uint256 timeElapsed =  block.timestamp - startingDates[msg.sender];
        if ((alreadyUsedPeriods[msg.sender][0] != true) && (timeElapsed >= YEAR) && (timeElapsed <= 2 * YEAR)) // TODO: test the body of the if statements
        {
            alreadyUsedPeriods[msg.sender][0] = true;
            token.transferFrom(address(this), msg.sender, amountToTransfer);
            emit Released(msg.sender, amountToTransfer);
            return true;
        }
        else if ((alreadyUsedPeriods[msg.sender][1] != true) && (timeElapsed >= 2 * YEAR) && (timeElapsed <= 3 * YEAR))
        {
            alreadyUsedPeriods[msg.sender][1] = true;
            token.transferFrom(address(this), msg.sender, amountToTransfer);
            emit Released(msg.sender, amountToTransfer);
            return true;
        }
        else if ((alreadyUsedPeriods[msg.sender][2] != true) && (timeElapsed >= 3 * YEAR) && (timeElapsed <= 4 * YEAR))
        {
            alreadyUsedPeriods[msg.sender][2] = true;
            token.transferFrom(address(this), msg.sender, amountToTransfer);
            emit Released(msg.sender, amountToTransfer);
            return true;
        }
        else if ((alreadyUsedPeriods[msg.sender][3] != true) && (timeElapsed > 4 * YEAR))
        {
            alreadyUsedPeriods[msg.sender][3] = true;
            token.transferFrom(address(this), msg.sender, amountToTransfer);
            emit Released(msg.sender, amountToTransfer);
            return true;
        }
        revert TriedToReleaseTooEarlyError();
    }

}
