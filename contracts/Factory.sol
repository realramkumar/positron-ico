pragma solidity ^0.4.23;

import 'contracts/PositronTokenIco.sol';


contract Factory {

    function createContract (
        address _fundsWallet,
        uint256 _startTimestamp,
        uint256 _minCapEth,
        uint256 _maxCapEth) public returns(address created) 
    {
        return new PositronTokenIco(
            _fundsWallet,
            _startTimestamp,
            _minCapEth * 1 ether,
            _maxCapEth * 1 ether
        );
    }
}