# Foundry-Fundme

Simple solidity contract with preforms basic fund and withdraw options developed using foundry.

## Run

To run the setup, first you need to install foundry dependency:

```
forge init
```
Then to run this setup simple preform:
```
forge build
```
## Requirements
1. You need to create .env file and within file you need to provide your private key(Make sure its either fake one or dummy wallet. Don't provide key with have real funds), your etherscan key and your sepolia rpc url
Format should be like this:
```
SEPOLIA_RPC_URL={...}
PRIVATE_KEY={...}
ETHERSCAN_API_KEY={...}
2.You can use MakeFile to shorten the commands