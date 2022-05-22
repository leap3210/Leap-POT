// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @custom:security-contact security-leap@mail.com
contract LeapHub {
  
    // NFT Contract to check listener LEAP protocol subscription 
    address public leapSubscriptionContract;
    
    struct Listener {
        
        // LEAP Token (ERC20) reward multiplayer
        // Update value on stake / unstake NFT tokens (subscritions)
        // Could be set by governcance contract. Default = 1
        uint256 leapRewardMultiplier;
        
        // Unclaimed, accumulated rewards in LEAP Token(ERC20)
        uint256 leapRewards;

        // Last time rewards were calculated on chain
        uint256 lastCheckpoint;

        // Owned LEAP NFT ID's
        uint256[] leapNFTs;

    }
    
    mapping (address => Listener) public listeners;
    mapping(uint256 => address) public subscriptionOwners;
    
    constructor (address _SubscriptionContract) {
        leapSubscriptionContract = _SubscriptionContract;
    }
    
    // Stake LeapNFT
    function stake(uint256[] _tokenIDs) public {
        
        Listener storage user = listeners[msg.sender];
        uint256 rewardMultiplier = user.leapRewardMultiplier;

        uint256 lenght = _tokenIDs.lenght;

        for (uint256 i = 0; i < lenght; i++) {
            
            // Check ownership of NFT's to stake
            require(leapSubscriptionContract.ownerOf(_tokenIDs[i]) == msg.sender, "NOT_OWNER");

            // Transfer NFT into LeapHub contract
            leapSubscriptionContract.safeTransferFrom(msg.sender, address(this), _tokenIDs[i]);

            // Update subscription owners
            subscriptionOwners[_tokenIDs[i]] = msg.sender;

            // Update reward multiplier rate according to amount NFT's staked
            if (rewardMultiplier >= 1) {
                rewardMultiplier += 0.1;
            } else {
                rewardMultiplier = 1;
            }

            user.leapNFTs.push(_tokenIDs[i]);
        }

        // Calculate rewards for subscriber
        accumulate(msg.sender);

        // Set new reward muiltiplier
        user.leapRewardMultiplier = rewardMultiplier;

    }
    
    // Unstake LeapNFT
    function unstake(uint256[] _tokenIDs) public {
        //    
    }

    // Claim rewards
    function claim() public {

    }

    function accumulate(address _subscriber) internal {
    }

    // Get Owners list of staked LeapNFTs

    // Whitelist of allowed NFT contracts to stake

    // Update timeToPay for staked NFT owners (Listeners)

}
