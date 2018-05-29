pragma solidity ^0.4.21;

import "./token/ERC20/MintableToken.sol";
import "./token/ERC20/CappedToken.sol";
import "./math/SafeMath.sol";
import "./ownership/Ownable.sol";

import "./token/ERC20/MintableToken.sol";

/**
 */
contract UmeToken is CappedToken 
{
    string public name = "UmeCoin";
    string public desc = "UME token used in the Umewin ecosystem";
    string public symbol = "UME";
    uint8 public decimals = 18;
    uint256 public amount = 200000000 * (uint(10) ** decimals);

    constructor() CappedToken(amount) public {
    }
}


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale is Ownable {
    using SafeMath for uint256;

    // The token being sold
    UmeToken public token;

    bool paused = false;

    bool bonus = false;

    // address where funds are collected
    address public wallet = 0xFDBb6ad2b5E1c14d6D649F7f99704B165Dc8D273;

    // how many token units a buyer gets per wei
    uint256 public rate = 2000;

    uint256 public bonusRate = 4000;

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
    * event for token    purchase logging
    * @param purchaser who paid for the tokens
    * @param beneficiary who got the tokens
    * @param value weis paid for purchase
    * @param amount amount of tokens purchased
    */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


    constructor() public {
        token = createTokenContract();
        // token.transferOwnership(msg.sender);
    }

    // fallback function can be used to buy tokens
    function () external payable {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = getTokenAmount(weiAmount);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        // TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    // @return true if crowdsale event has ended
    function isPaused() public view returns (bool) {
        return paused;
    }

    function isBonusEnabled() public view returns (bool) {
        return bonus;
    }


    // creates the token to be sold.
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (UmeToken) {
        return new UmeToken();
    }

    // Override this method to have a way to add business logic to your crowdsale when buying
    function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        uint256 rateToApply = bonus ? bonusRate : rate;
        return weiAmount.mul(rateToApply);
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal view returns (bool) {
        bool nonZeroPurchase = msg.value != 0;
        return !paused && nonZeroPurchase;
    }

    function pause() public  onlyOwner {
        paused = true;
    }

    function unpause() public  onlyOwner {
        paused = false;
    }

    function enableBonus() public  onlyOwner{
        bonus = true;
    }

    function disableBonus() public  onlyOwner{
        bonus = false;
    }

    function transferTokenOwnership() public onlyOwner {
        token.transferOwnership(msg.sender);
    }

    function mint(address beneficiary, uint256 tokens) public onlyOwner {
        token.mint(beneficiary, tokens);
    }



}
