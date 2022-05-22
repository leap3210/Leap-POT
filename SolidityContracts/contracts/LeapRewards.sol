// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @custom:security-contact security-leap@mail.com
contract LeapRewards {
    
    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    
    // Reward rate for LEAP Token
    // Could be set by goverment contract
    uint256 public baseLeapRewardRate = 1 * 10 ** 18;
    
    // Reward destribution frequency (seconds)
    uint256 public leapRewardFrequency = 5; 
    
    // Calculate reward values according to RewardPool of a Host Event and his Listeners contribution

    // Transfer reward assets from RewardPool into Superfluid contract

    // Set recipients and amounts to recieve for Superfluid contract

    // Update timeToPay for staked NFT owners (Listeners) on LeapHub.sol contract
    // Set timeToPay to 0
    // Set lastTimePaid to current blockstamp
    
}