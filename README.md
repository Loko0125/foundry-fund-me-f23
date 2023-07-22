
# Foundry Fund Me

This contract allow multiple Players to participate and send some ETH and one winner will be chosen at random. After a specified time has passed, the winning Eths will be sent. we use solidity as language and Foundry as Framework.

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  
  => You'll know you did it right if you can run ```git --version``` and you see a response like ```git version x.x.x```

- [foundry](https://getfoundry.sh/)

  => You'll know you did it right if you can run ```forge --version``` and you see a response like ```forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)```

## Usage

Deploy:

```bash
forge script scripts/DeployFundMe.s.sol
```

## Testing

To run test:

```bash
forge test
```
or

```bash
// Only run test functions matching the specified regex pattern.

"forge test --mt testFunctionName" 
```

or

```bash
forge test --fork-url $SEPOLIA_RPC_URL 
```
## Test Coverage

```bash
forge coverage
```

## Deployment to a testnet or mainnet

  1- Setup environment variables

  - You'll want to set your ```SEPOLIA_RPC_URL``` and ```PRIVATE_KEY``` as environment variables.

  - Optionally, add your ```ETHERSCAN_API_KEY``` if you want to verify your contract on Etherscan.

  2- Get testnet ETH

  - Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH.

3- Deploy

 ```bash
 forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Estimate gas

You can estimate how much gas things cost by running:

```bash
 forge snapshot
```
And you'll see an output file called ```.gas-snapshot```

## Thank you!
You can find me:

[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/AyoubAkrim)
