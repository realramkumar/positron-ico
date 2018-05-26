pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol';


contract PositronTokenIco is StandardToken {
    using SafeMath for uint256;

    string public name = "Positron Token";
    string public symbol = "XPN";
    uint256 public decimals = 18;

    uint256 public totalSupply = 105000000 * (uint256(10) ** decimals);
    uint256 public totalRaised; // total ether raised (in wei)

    uint256 public startTimestamp = 1527358440; // timestamp after which ICO will start
    uint256 public durationSeconds = 57 * 24 * 60 * 60; // 4 weeks

    uint256 public minCap = 2889 * (uint256(10) ** decimals); // the ICO ether goal (in wei)
    uint256 public maxCap = 2975 * (uint256(10) ** decimals); // the ICO ether max cap (in wei)

    /**
     * Address which will receive raised funds 
     * and owns the total supply of tokens
     */
    address public fundsWallet = 0xbf433E428cf963AAe13cA3D58B2f36F2d8E7498c;

    
    constructor() public {
        // initially assign all tokens to the fundsWallet
        balances[fundsWallet] = totalSupply;
        emit Transfer(0x0, fundsWallet, totalSupply);

    }

    function() isIcoOpen payable public {
        totalRaised = totalRaised.add(msg.value);

        uint256 tokenAmount = calculateTokenAmount(msg.value);
        balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
        balances[msg.sender] = balances[msg.sender].add(tokenAmount);
        emit Transfer(fundsWallet, msg.sender, tokenAmount);

        // immediately transfer ether to fundsWallet
        fundsWallet.transfer(msg.value);
    }

    function calculateTokenAmount(uint256 weiAmount) constant private returns(uint256) {
        uint256 tokenAmount;
        uint256 initialDiscount = 666 * 1 ether;
        if (totalRaised < initialDiscount) {
            tokenAmount = weiAmount.mul(2700);
        } else {
            tokenAmount = weiAmount.mul(2400);
        }
        return tokenAmount;
    }

    function transfer(address _to, uint _value) isIcoFinished public returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) isIcoFinished public returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    modifier isIcoOpen() {
        require(now >= startTimestamp);
        require(now < (startTimestamp + durationSeconds) || totalRaised < minCap);
        require(totalRaised <= maxCap);
        _;
    }

    modifier isIcoFinished() {
        require(now >= startTimestamp);
        require(totalRaised >= maxCap || (now > (startTimestamp + durationSeconds) && totalRaised >= minCap));
        _;
    }
}