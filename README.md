# ERC20

This repo defines a contract called ERC20TD, which is a type of ERC20 token contract. It has several functions and features including:

A constructor function that takes four arguments: a name, symbol, initial supply, and an instance of the Evaluator contract. It sets the name, symbol, and totalSupply variables based on the values returned by the ex1_getTickerAndSupply() function of the Evaluator contract.

A distributeTokens function that allows only teachers to mint new tokens for a given address. It calculates the number of tokens to be minted based on the decimals value of the contract and a multiplicator.

A setTeacher function that allows teachers to set the teacher status of a given address.

A onlyTeachers modifier that requires the calling address to be a teacher.

A transfer function that overrides the default transfer function of the ERC20 contract and prevents any transfers from happening. It also emits a DenyTransfer event.

A transferFrom function that overrides the default transferFrom function of the ERC20 contract and prevents any transfers from happening. It also emits a DenyTransferFrom event.

A getToken function that requires the calling address to be on the allowList and distributes tokens to the caller.

A buyToken function that allows the caller to buy tokens by sending an amount of ETH to the contract. It calculates the number of tokens to be distributed based on the decimals value of the contract and a multiplicator.

A setCustomerAllowList function that allows the owner to set the allow status of a given customer.

An addToAllowList function that allows the owner to add a customer to the allow list.

A removeFromAllowList function that allows
