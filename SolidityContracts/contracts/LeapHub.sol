// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/// @custom:security-contact leap@mail.com
/// With mark "Leap security"
contract LeapHub {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("ADMINISTARTOR_ROLE");
  
    // NFT Contract to check listener's LEAP protocol subscription 
    address public leapSubscriptionContract;
    
    // Leap reward token contract (ERC20)
    address public leapTokenContract;
    
    struct Listener {
        
        // LEAP Token (ERC20) reward multiplayer
        // Update value on stake / unstake NFT tokens (subscritions)
        // Could be set by governcance contract. Default = 1
        uint256 leapRewardMultiplier;
        
        // Unclaimed, accumulated rewards in LEAP Token(ERC20)
        uint256 leapRewards;

        // Last time rewards were calculated on chain
        uint256 lastCheckpoint;

    }
    
    mapping (address => Listener) public listeners;
    mapping (uint256 => address) public subscriptionOwners;

    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    
    // Reward rate for LEAP Token
    // Could be set by goverment contract
    uint256 public baseLeapRewardRate;

    uint256 public initLeapRewardMultiplier;
    uint256 public addLeapRewardMultiplier;
    
    // Reward destribution frequency (seconds)
    uint256 public leapRewardFrequency;
    
    constructor (address _SubscriptionContract, address _leapTokenContract) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(ADMINISTARTOR_ROLE, msg.sender);
        
        leapSubscriptionContract = _SubscriptionContract;
        leapTokenContract = _leapTokenContract;
        setBaseLeapRewardRate(1 * 10 ** 18);
        setLeapRewardFrequency(5 * 60);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    //////////////////////////////////////////////////////
    /// Leap protocol's parameters set
    /// Available for specified role only
    
    // Set reward rate for Leap token
    function setBaseLeapRewardRate(uint256 _rewardRate) public onlyRole(ADMINISTARTOR_ROLE) {
        baseLeapRewardRate = _rewardRate;
    }

    // Set Reward destribution frequency (seconds)
    function setLeapRewardFrequency(uint256 _leapRewardFrequency) public onlyRole(ADMINISTARTOR_ROLE) {
        leapRewardFrequency = _leapRewardFrequency;
    }

    function setInitLeapRewardMultiplier(uint256 _multiplier) public onlyRole(ADMINISTARTOR_ROLE) {
        initLeapRewardMultiplier = _multiplier;
    }

    function setAddLeapRewardMultiplier(uint256 _multiplier) public onlyRole(ADMINISTARTOR_ROLE) {
        addLeapRewardMultiplier = _multiplier;
    }

    //////////////////////////////////////////////////////
    /// Leap protocol's NFT logic (subscriptions)
    
    // Stake LeapNFT
    function stake(uint256[] memory _tokenIDs) public {
        
        Listener storage user = listeners[msg.sender];
        uint256 rewardMultiplier = user.leapRewardMultiplier;

        uint256 lenght = _tokenIDs.lenght;

        for (uint256 i = 0; i < lenght; i++) {
            
            // Check ownership of NFT's to stake
            require(leapSubscriptionContract.ownerOf(_tokenIDs[i]) == msg.sender, "NOT_OWNER");

            // Transfer NFT into LeapHub contract
            leapSubscriptionContract.safeTransferFrom(msg.sender, address(this), _tokenIDs[i]);

            // Update subscription owners list
            subscriptionOwners[_tokenIDs[i]] = msg.sender;

            // Update reward multiplier rate according to amount NFT's staked
            if (rewardMultiplier >= initLeapRewardMultiplier) {
                rewardMultiplier += addLeapRewardMultiplier;
            } else {
                rewardMultiplier = initLeapRewardMultiplier;
            }
        }

        // Calculate rewards for subscriber
        accumulate(msg.sender);

        // Set new reward muiltiplier
        user.leapRewardMultiplier = rewardMultiplier;

    }
    
    // Unstake LeapNFT
    function unstake(uint256[] memory _tokenIDs) public {

        Listener storage user = listeners[msg.sender];
        uint256 rewardMultiplier = user.leapRewardMultiplier;

        uint256 lenght = _tokenIDs.lenght;

        for (uint256 i = 0; i < lenght; i++) {
            
            // Check ownership of NFT's to unstake
            require(subscriptionOwners[_tokenIDs[i]] == msg.sender, "NOT_OWNER");
            require(leapSubscriptionContract.ownerOf(_tokenIDs[i]) == address(this), "NOT_STAKED");

            // Transfer NFT to token owner
            leapSubscriptionContract.safeTransferFrom(address(this), msg.sender, _tokenIDs[i]);

            // Update subscription owners list
            subscriptionOwners[_tokenIDs[i]] = address(0);
            
            // Update reward multiplier rate according to amount NFT's staked
            if (rewardMultiplier > initLeapRewardMultiplier) {
                rewardMultiplier -= addLeapRewardMultiplier;
            } else {
                rewardMultiplier = 0;
            }
        }

        // Calculate rewards for subscriber
        accumulate(msg.sender);

        // Set new reward muiltiplier
        user.leapRewardMultiplier = rewardMultiplier;

    }

    //////////////////////////////////////////////////////
    /// Rewards logic
    
    // Claim rewards
    function claim() public {
        
        Listener storage user = listeners[msg.sender];
        accumulate(msg.sender);

        // Send available rewards to listener
        leapTokenContract._mint(msg.sender, user.leapRewards);
        
        // Set available rewards to claim for listener to 0
        user.leapRewards = 0;
        
    }

    // Accumulate rewards
    function accumulate(address _subscriber) internal {
        
        // Set accumulated rewards available to claim
        listeners[_subscriber].leapRewards += getRewards(_subscriber);
        
        // Set last chekpoint for reward accumulation
        listeners[_subscriber].lastCheckpoint = block.timestamp;
        
    }
    
    // Calculate listener rewards
    function getRewards(address _subscriber) public view returns (uint256) {
        
        Listener memory user = listeners[_subscriber];

        if (user.lastCheckpoint == 0) {
            return 0;
        }

        return((block.timestamp - user.lastCheckpoint) * (user.leapRewardMultiplier * baseLeapRewardRate)) / SECONDS_PER_DAY;
    }

    // Calculate reward values according to RewardPool of a Host Event and his Listeners contribution

    // Transfer reward assets from RewardPool into Superfluid contract

    // Set recipients and amounts to recieve for Superfluid contract

    // Update timeToPay for staked NFT owners (Listeners) on LeapHub.sol contract
    // Set timeToPay to 0
    // Set lastTimePaid to current blockstamp
    
    //////////////////////////////////////////////////////
    
    // Get Owners list of staked LeapNFTs

    // Whitelist of allowed NFT contracts to stake

    // Update timeToPay for staked NFT owners (Listeners)

    
    
    //////////////////////////////////////////////////////

    /// User registry part

    // Register host (Stake NFT)

    // Register host event / project (Twitter Space)

    // Set reward for event (Transfer ERC20)

    // Turn-off Leap rewards

}