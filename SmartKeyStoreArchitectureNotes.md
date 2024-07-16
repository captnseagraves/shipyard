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
A cosmos app chain
A striped down op stack instance
A smart wallet keystore contract on Base
Need CRUD operations for the key store
Need interfaces for each supported chain
Start with the OP stack chains

Concerns:
This could hold billions worth of value in the future and needs to be extremely secure. 

Questions to be answered: 

