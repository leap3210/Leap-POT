// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @custom:security-contact security-leap@mail.com
contract LeapHub {
  
    address public leapSubscriptionNFT;

    constructor (address _NFTContract) {
        leapSubscriptionNFT = _NFTContract;
    }
    
    // Stake LeapNFT
    function stake(address _SubscriptionNFTContract, uint256 _tokenID) public {

    }
    
    // Unstake LeapNFT
    function unstake(address _SubscriptionNFTContract, uint256 _tokenID) public {
        
    }

    // Get Owners list of staked LeapNFTs

    // Whitelist of allowed NFT contracts to stake

    // Update timeToPay for staked NFT owners (Listeners)

}
