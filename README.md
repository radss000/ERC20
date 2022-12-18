# ERC20

This is the code for a smart contract written in Solidity, a programming language used to write smart contracts for the Ethereum blockchain. The contract is called ERC20TD, and it appears to be an implementation of the ERC20 standard for tokens on Ethereum, with additional functionality for managing a whitelist of approved customers, and for setting different customer tiers with different token purchase limits.

The contract has an Evaluator contract as a dependency, which is used to get the ticker symbol and initial token supply for the contract. It also has a constructor function that is called when the contract is deployed, which sets the name, symbol, and totalSupply of the token based on the ticker and supply returned by the Evaluator, and sets the owner of the contract to the sender of the deployment transaction.

The contract also has several functions that can be called by external actors:

- distributeTokens: allows a teacher (an address with the teachers mapping set to true) to mint and distribute a specified amount of tokens to a specified address.
- setTeacher: allows an existing teacher to add or remove another address as a teacher.
- transfer and transferFrom: override the default ERC20 implementations of these functions to always return false and emit the DenyTransfer or DenyTransferFrom event, effectively disabling transfers of the token.
- setCustomerAllowList, addToAllowList, and removeFromAllowList: allow the contract owner to set, add, or remove addresses from a whitelist of approved customers.
- getToken: allows an approved customer to request and receive a specified amount of tokens from the contract.
- setCustomerTier and setTokenMultiplier: allow the contract owner to set the customer tier for a given address, or to set the token multiplier for a given customer tier. The token multiplier determines the number of tokens that can be purchased for a given amount of ETH, depending on the customer's tier.
- buy: allows a customer to purchase tokens using ETH, with the number of tokens depending on their tier and the token multiplier for that tier.

