Purpose: 
The goal of this exercise is to create a decentralized action specific blockchain that enables smart wallet smart contracts to remain in sync across arbitrary chains.

Problem:
Smart wallets are owned by passkey based private keys. Smart wallets are smart contracts deployed independently across many chains. These can have the same address through create2, but after deployment each instance does not have awareness of any other instance. If a smart wallet owner or signer key is updated on one chain the other instances are not aware of the update. 

Solution: 
Create a decentralized action specific blockchain that can rotate or update keys as needed and serve as a single reference point for all instances of a smart wallet address. 

Attributes needed:
Plan for progressive decentralization
Trusted centralized entity could run this from an EC2 instance to begin
A centralized service can teach us many things about this service, answer questions, and uncover aspects we maybe did not expect.
POC would be to deploy smart wallets on base sepolia and OP sepolia and update keys from an EC2 instance. EC2 would need to be updated from a passkey. 
Security concerns could warrant us to build this decentralized from scratch
A decentralized architecture could mean….
An Eigenlayer AVS
Who are the operators and what actions do they perform? 
How are they rewarded
A cosmos app chain
A striped down op stack instance
A smart wallet keystore contract on Base
Need CRUD operations for the key store
Need interfaces for each supported chain
Start with the OP stack chains
Need to support multiple signer keys(?)
Essentially run this contract into an AVS
https://github.com/coinbase/smart-wallet/blob/main/src/MultiOwnable.sol
Or have a main MultiOwnable contract and use a DA layer or create a key DA layer

Architecture: 
An pool of Eigen registered AVS operators are running smart key management software
A user wants to update their keys for a given smart wallet address
Operators each submit and propose the provided key value
Upon a threshold being reached and key value accepted the value is updated in the shared state
If an operator submits a value that is different than the majority they will be slashed.
This prevents a single actor from accepting a new key value but providing their own value instead. 
End Users (smart wallet clients) can read from the smart key management AVS before submitting a transaction to ensure they are up to date, and if needed they can submit a transaction to update the key value 

Concerns:
This could hold billions worth of value in the future and needs to be extremely secure. 

Questions to be answered: 
Can this simply be addressed by existing data availability layers and selecting a canon multiowner contract and chain? Like, cool we all choose to believe the owner contract on Base and query Celestia or EigenDA as an onchain oracle for the data? 



Thoughts:
Smart wallets could take a small fee on any transaction. It is a better UX for wallets. Every wallet will become a smart wallet. The Keystore will become very valuable and will need to be trusted by many clients, or there will be many services for each client. But if you could create one that is credibly neutral it would be a critical piece of infrastructure. 



