# TeamWallet Smart Contract

The TeamWallet smart contract is an Ethereum-based contract that allows a team to manage a shared wallet and approve spending transactions. This contract is useful for teams who want to collaboratively control funds and ensure responsible spending.

## Features

1. **Set Wallet**: The deployer of the contract can initialize the wallet by specifying team members' addresses and the initial amount of credits available.

2. **Spend Credits**: Team members can propose spending transactions by specifying the amount they want to spend.

3. **Approve Transactions**: Team members can approve proposed spending transactions.

4. **Reject Transactions**: Team members can reject proposed spending transactions.

5. **View Credits**: Team members can check the available credits in the wallet.

6. **View Transaction Details**: Team members can view details of a specific transaction, including its status (pending, debited, or failed).

7. **Transaction Statistics**: Team members can view statistics about the executed, pending, and failed transactions.

## Structs

- `Transaction`: A struct representing a spending transaction with the following properties:
  - `amount`: The amount of credits to spend.
  - `approvals`: The number of approvals received.
  - `rejections`: The number of rejections received.
  - `executed`: A flag indicating whether the transaction has been executed.
  - `failed`: A flag indicating whether the transaction has failed.

## Functions

- `setWallet(address[] memory _members, uint _credits)`: Allows the deployer to set up the wallet with team members and initial credits.

- `spend(uint _amount)`: Allows team members to propose spending transactions.

- `approve(uint _n)`: Allows team members to approve a specific spending transaction.

- `reject(uint _n)`: Allows team members to reject a specific spending transaction.

- `credits()`: Returns the available credits in the wallet.

- `viewTransaction(uint _n)`: Returns details about a specific transaction, including its status and amount.

- `transactionStats()`: Returns statistics on the number of debited, pending, and failed transactions.

## Modifiers

- `onlyDeployer()`: Ensures that a function can only be called by the deployer of the contract.

- `onlyMembers()`: Ensures that a function can only be called by team members.

- `transactionExists(uint n)`: Ensures that a transaction with a given index exists.

## Usage

You can interact with this smart contract through Ethereum-compatible wallets or by deploying it to the Ethereum blockchain. To get started, you can compile and deploy the contract using a development environment like Remix or Truffle.

## License

This smart contract is provided under the MIT License.
