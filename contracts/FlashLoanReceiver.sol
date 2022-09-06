// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Token.sol";
import "./FlashLoan.sol";
import "hardhat/console.sol";

contract FlashLoanReceiver {
    FlashLoan private pool; 
    address private owner;

    event LoanReceived(address token, uint256 amount); 

    constructor(address _poolAddress) {
        owner = msg.sender;
        pool = FlashLoan(_poolAddress);
    }

    function receiveTokens(address _tokenAddress, uint256 _amount) external {
        require(msg.sender == address(pool),"Sender must be pool");

        //Require funds received
        require(Token(_tokenAddress).balanceOf(address(this)) == _amount, "failed to get loan");


        //Emit event to prove tokens received
        emit LoanReceived(_tokenAddress, _amount);


        //Arbitrage
        //console.log("_tokenAddress", _tokenAddress, "_amount", _amount);
        //console.log("", Token(_tokenAddress).balanceOf(address(this)));

        //Return funds to pool
        require(Token(_tokenAddress).transfer(msg.sender, _amount), "Transfer of tokens failed"); 
    

    }

    function executeFlashLoan(uint256 _amount) external {
        require(msg.sender == owner, "Only owner can execute flash loan");
        pool.flashLoan(_amount);

    }

}