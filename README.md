# BLOCKCHAIN ASSIGNMENT 2

## TEAM MEMBERS

<ol> 
<li> Ninad Agrawal
<li> Aryan Saluja
<li> Abhishek Johi
<li> Vansh Gupta
<li> Om Mishra
</ol>

### There are 2 Contracts as part of this assigment

 <li> CustomToken.sol
 <li> Logic.sol

<br>

# CustomToken.sol

 <p> It inherits from the OpenZeppelin ERC20 and ERC20Burnable contracts to create a custom token called "XYZToken" with the symbol "XYZT." 
<li>import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
<li>import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

## State Variables

<h3>companyacc:</h3> 
An address variable representing the company's account. This address is set to the deployer's address when the contract is created.

## Constructor

<h3>constructor():<h3> 
This is the constructor of the customToken contract. It initializes the token with the name "DiscountToken" and the symbol "DIST." It also mints 10,000 tokens and approves the deployer's address for spending those tokens.

## Functions

### Token Approval

approve(address spender, uint256 value): This function allows the company's account to approve another address (spender) to spend a specified amount of tokens. It calls the internal \_approve function provided by the ERC20 contract.

### Token Transfer

transferFrom(address from, address to, uint256 value): This function allows the company's account (spender) to transfer tokens from one address (from) to another (to). It first checks the allowance using the \_spendAllowance function, transfers the tokens using the \_transfer function, and returns a boolean value indicating success.

### Token Burning

burnFrom(address account, uint256 value): This function enables the company's account to burn a specified amount of tokens from another address (account). It first checks the allowance using the \_spendAllowance function and then calls the \_burn function to destroy the tokens.

<br>

# Main.sol

<p>
<li>The XYZStore contract serves as a digital store that allows customers to buy products using Ether and custom tokens (XYZToken). The main Idea behind the implementation has been that for every transaction that a consumer makes , they are rewarded with 5 tokens.<li>They can then use these tokens that they receive as reward for buying any amount of any kind of product , in order to avail discounts on their future transactions.
<li>The discounts that they are able to avail depend in the number of tokens that they have obtained by virtue of buying products and performing new trasactions.
<li>The discounts are as follows :
        <ol>
        <li> 5 tokens : 5% discount
        <li> 10 tokens : 10% discount
        <li> 15 tokens : 15% discount
        <li> 20 tokens : 20% discount
        <li> 25 tokens : 25% discount
        </ol>
</p>

## State Variables

#### xyzToken:

A public variable representing the XYZToken contract. It is used for handling token transfers and accessing the burn function to apply discounts.

#### admin:

An address variable representing the administrator of the store. This address is set to the deployer's address and is payable.

#### Discount Thresholds:

Constants representing token balance thresholds for different discount levels, including TEN_TOKENS, TWENTY_TOKENS, THIRDTY_TOKENS, FOURTY_TOKENS, and FIFTY_TOKENS.

#### validatedcustomers:

A mapping that tracks which customers have been validated by the administrator.

## Constructor

### constructor(address \_xyzToken) payable:

The constructor of the XYZStore contract accepts the address of the XYZToken contract during deployment. It initializes the XYZToken contract instance and assigns the deployer's address as the admin. It is also marked as payable, allowing the contract to receive Ether.

## Modifiers

### onlyAdmin:

A modifier that restricts access to functions for the admin, ensuring that only the admin can execute certain operations.

## Receive and Fallback Functions

### receive() external payable:

The receive function allows the contract to receive Ether. It is used to top up the store's balance with Ether.

### fallback() external payable:

The fallback function also allows the contract to receive Ether, providing flexibility for receiving payments.

## Customer Validation

### validateCustomer(address cust) external onlyAdmin returns (uint256):

This function is used by the admin to validate a customer. It approves the customer to spend 5 XYZTokens and updates the validatedcustomers mapping. It returns the approved token allowance.

## Sending Ether

## Buying Products

### buyProduct(bool wantDiscount) public payable returns (uint256):

Customers use this function to buy products. They can specify whether they want a discount. The function checks if the customer has enough Ether balance, is validated by the admin, and calculates the discount if requested. It then transfers Ether and XYZTokens accordingly. The return value is the updated customer balance.

## Discount Calculation

### availDiscount() internal returns (uint256):

This internal function calculates the discount amount based on the customer's XYZToken balance and the predefined discount thresholds. The function determines the discount, applies it by burning XYZTokens, and returns the calculated discount amount.

## Usage

To use the XYZStore contract, follow these steps:

<ol>
<li>Deploy the XYZStore contract, providing the address of the XYZToken contract during deployment.
<li>As the admin, validate customers using the validateCustomer function, allowing them to spend tokens.
<li>Customers can call the buyProduct function to purchase products with or without discounts.
<li>If eligible for a discount, the function will apply it by burning XYZTokens and transfer Ether and tokens accordingly. The function will deduct tokens from a customer's account according to the discount appliedand will give the remiaing tokens back to the customer as a sort of " Cashback" on the discounted payment.
</ol>

#### Note : In our implementation , we have considered the price of all products in the store to be 1 token. This can be changed in further implementation if required but has been taken as a standard for ease of understanding and overall convenience.
