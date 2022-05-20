// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

/// @custom:security-contact security-leap@mail.com
contract LeapUserRegistry {

    mapping (address -> Listener);
    
    struct Listener {
        // LEAP Token (ERC20) reward multiplayer. Default value 1.
        uint256 leapRewardMultiplier;
        // Unclaimed, Accumulated LEAP Token rewards
        uint256 leapRewards;
        // Last time rewards were calculated on chain
        uint256 lastCheckpoint;
        // LEAP NFT ID's ownership
        uint256[] leapNFTs;
    }

    // Register host (Stake NFT)

    // Register host event / project (Twitter Space)

    // Set reward for event (Transfer ERC20)

    // Turn-off Leap rewards
    
}