# ERC20

This is the code for a smart contract written in Solidity. The contract is called ERC20TD, and it is an implementation of the ERC20 standard for tokens on Ethereum, with additional functionality for managing a whitelist of approved customers, and for setting different customer tiers with different token purchase limits.

The contract has an Evaluator contract as a dependency, which is used to get the ticker symbol and initial token supply for the contract. It also has a constructor function that is called when the contract is deployed, which sets the name, symbol, and totalSupply of the token based on the ticker and supply returned by the Evaluator, and sets the owner of the contract to the sender of the deployment transaction.

The contract also has several functions that can be called by external actors:

- distributeTokens: allows a teacher (an address with the teachers mapping set to true) to mint and distribute a specified amount of tokens to a specified address.
- setTeacher: allows an existing teacher to add or remove another address as a teacher.
- transfer and transferFrom: override the default ERC20 implementations of these functions to always return false and emit the DenyTransfer or DenyTransferFrom event, effectively disabling transfers of the token.
- setCustomerAllowList, addToAllowList, and removeFromAllowList: allow the contract owner to set, add, or remove addresses from a whitelist of approved customers.
- getToken: allows an approved customer to request and receive a specified amount of tokens from the contract.
- setCustomerTier and setTokenMultiplier: allow the contract owner to set the customer tier for a given address, or to set the token multiplier for a given customer tier. The token multiplier determines the number of tokens that can be purchased for a given amount of ETH, depending on the customer's tier.
- buy: allows a customer to purchase tokens using ETH, with the number of tokens depending on their tier and the token multiplier for that tier.

# ERC 721

This is an ERC721 contract for a virtual pet game called "Raddit". In the game, players can breed and trade unique creatures called "Raddits".

Features
Players can register as breeders by calling the registerBreeder function. Only certain addresses are allowed to register as breeders.
Breeders can create new Raddits by calling the ex2a_getAnimalToCreateAttributes function and declaring the Raddit's name and type with the declareAnimal function. The new Raddit is minted and assigned to the Evaluator contract.
Breeders can declare the parents of a Raddit when creating it using the declareAnimalWithParents function. The parent Raddits must already exist.
Players can view the details of a Raddit, including its name, type, and parent IDs, using the creatures mapping.
Players can offer a Raddit for sale by calling the offerAnimalForSale function. The sale price must be specified in wei.
Players can view the sale status and price of a Raddit using the getAnimalSaleDetails function.
Players can buy a Raddit that is for sale by calling the buyAnimal function and sending the required amount of ether. The Raddit's ownership is transferred to the buyer.
Breeders can offer a Raddit for reproduction, against payment, by calling the `offerAnimal ForReproduction` function and specifying the price in wei.

Players can view the reproduction status and price of a Raddit using the getAnimalReproductionDetails function.
Players can pay for the reproductive rights of a Raddit by calling the payForReproduction function and sending the required amount of ether. The ether is transferred to the owner of the Raddit.

Notes

The contract imports the @openzeppelin/contracts library for the ERC721 implementation.
The contract implements the IExerciceSolution interface, which is defined in the IExerciceSolution.sol file.
The contract also imports the Evaluator.sol and Evaluator2.sol files, which contain the functions for the points system.
The contract uses the Counters contract from @openzeppelin/contracts for the mintAndAssignToEvaluator function.
The contract has a constructor function that calls the constructor function of the ERC721 contract to initialize the contract with a name and symbol.
