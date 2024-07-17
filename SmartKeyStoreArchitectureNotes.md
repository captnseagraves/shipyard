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
Need integration for interface into smart wallet ownership system for it to work and make sense. 

The scenario we wan to avoid is an a colluding group of validators providing a compromised key as a valid owner of a smart wallet that controls a large sum of value, draining it and compromising the integrity of the system 
The system will need sufficient economic AND decentralized trust. 
Decentralised trust will be more important, if there are sufficient nodes providing a response then we can have confidence that they are not colluding to provide a false answer that could enable an attacker to completely drain a wallet on an external chain. 
Economic trust will also be important. We likely want to have a reasonably high amount of aggregate economic trust, I’m trowing out $1m of economic trust, behind every interaction. At the time of writing this is about 10 validators worth of economic trust. 
10 validators is likely a high enough decentralized trust as well, but need to identify a metric that makes sense for amount of decentralized trust. 
Even 3 validators is $300,000 in economic trust. 
Perhaps there will be a simple majority submission of the answer, anyone not in the majority, or “Longest chain” will be slashed. So, someone would need to have enough validators colluding in a given set to take the majority and risk $600,000 in value to create a nefarious txn. 
Let’s start with these variables to go with. 10 Validators. 
How are the validators incentivized?
One monetization model is to charge for a read. 
The assumption would be that wallets would only need to read from the Smart key management system if they are expecting an update on the canonical multiOwner instance. They can execute an operation on any chain without the need for the smart key management system 
However if there is a key added or rotated on the canonical chain, the external chains need to be able to query and update the key. 
This external functional should be callable by anyone willing to pay the fee to update the owner key. The only way to update the key is via the smart key management system which references the canonical ownership contract on the canonical chain. 
Thus validators are paid per query they respond to, and users only pay for the queries they make when updating they keys. 

Concerns:
This could hold billions worth of value in the future and needs to be extremely secure. 

Questions to be answered: 
Can this simply be addressed by existing data availability layers and selecting a canon multiowner contract and chain? Like, cool we all choose to believe the owner contract on Base and query Celestia or EigenDA as an onchain oracle for the data? 



Thoughts:
Smart wallets could take a small fee on any transaction. It is a better UX for wallets. Every wallet will become a smart wallet. The Keystore will become very valuable and will need to be trusted by many clients, or there will be many services for each client. But if you could create one that is credibly neutral it would be a critical piece of infrastructure. 
Having it be an independent set of multiownership contracts is desirable because then you don’t have coinbase or whoever owning the canonical service. 

Options:
Centralized service
Not Secure enough - Trusted actor
Have a multiOwner contract deployed on a chain and query a DA service to enable cross chain ownership
Requires integration by smart wallet client contracts
Have a multiOwner the computes the multiowner signatures, etc off chain and supplies them when queried. 
Seeeeeems heavy
Have a canonical smart contract and have an AVS provide a DA service specifically for this use case
Requires integration by smart wallet client contracts

Regardless of an in-house or 3rd party DA layer, that needs to be:
 A canonical smart key management smart contract
An interface for querying current owners from any given chain.
This could be similar to
https://go.chainalysis.com/chainalysis-oracle-docs.html
https://docs.delegate.xyz/technical-documentation/delegate-registry/idelegateregistry.sol
Because the keys are such sensitive information you probably want to have multiple node operators providing the answer, and 




