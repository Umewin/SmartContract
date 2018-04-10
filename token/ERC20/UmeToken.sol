pragma solidity ^0.4.21;

import "./CappedToken.sol";

/**
 * @title UmeToken
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