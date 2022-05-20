# Smart contracts
## LeapNFT

Basic NFT contract: Pausable, Mintable, Burnable, with Roles

+ let Mint to anyone.
+ let Burn available only for NFT token owner.

+ Pausable only by contract owner.
- On pause people can't Mint, Burn, Transfer

Possible probs:
In case we eliminated stake, someone could publish Leap NFT on marketplace,
And for our BOT logic it will look like the owner been changed (because seller sent it into market place contract)
And after comparing new wallet address with BOT's data base, he would find pair wallet-twitter 
So no rewards would be distributed.

Additions:
Implementation for IPFS CID and tokenURI once generative art is ready. 

