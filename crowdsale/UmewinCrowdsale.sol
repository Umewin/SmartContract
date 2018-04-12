pragma solidity ^0.4.21;

import "../crowdsale/validation/CappedCrowdsale.sol";
import "../crowdsale/distribution/RefundableCrowdsale.sol";
import "../crowdsale/emission/MintedCrowdsale.sol";
import "../token/ERC20/MintableToken.sol";


/**
 */
contract UmeToken is CappedToken 
{
  string public name = "Umewin Coin";
  string public desc = "UME token used in the Umewin ecosystem";
  string public symbol = "UME";
  uint8 public decimals = 18;
  uint256 public constant INITIAL_SUPPLY = 100000000;

  function UmeToken() CappedToken(amount) public {
      owner = msg.sender;
  }
}


/**
 * @title SampleCrowdsale
 */
contract UmewinCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {

  function UmewinCrowdsale(
    uint256 _openingTime,
    uint256 _closingTime,
    uint256 _rate,
    address _wallet,
    uint256 _cap,
    // CappedToken _token,
    uint256 _goal
  )
    public
    Crowdsale(_rate, _wallet, new UmeToken())
    CappedCrowdsale(_cap)
    TimedCrowdsale(_openingTime, _closingTime)
    RefundableCrowdsale(_goal)
  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }
}