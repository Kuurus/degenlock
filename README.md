# StarkNet Liquidity Locker

Welcome to the degenlock StarkNet Liquidity Locker project! This project aims to create a liquidity locker leveraging the StarkNet network, a Layer 2 scaling solution for Ethereum, to ensure secure and efficient locking of liquidity in a decentralized manner.

## Table of Contents
- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)

## Overview

The StarkNet Liquidity Locker is designed to provide projects with a means to lock liquidity in a secure and non-custodial way. By utilizing StarkNet’s Layer 2 scaling, the locker offers fast and cost-effective transactions while maintaining the security of the Ethereum mainnet.

## Technology Stack

- **Smart Contract Language:** Cairo
- **Network:** Ethereum Layer 2 - StarkNet

## Installation

Before you begin, make sure you have [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed.

1. **Clone the Repository**
   
   ```sh
   git clone https://github.com/Kuurus/degenlock.git
   cd degenlock
   ```
2. **Install Dependencies**
   ```sh
   npm install
   ```
3. **Compile Cairo Contracts**
   ```sh
   cairo-compile cairo1.cairo --output cairo1.json
   ```
4. **Deploy Contracts to StarkNet**

   Follow the deployment guide in the [StarkNet documentation](https://starknetpy.readthedocs.io/en/latest/guide/deploying_contracts.html).

## Usage

After deploying the contracts to the StarkNet network, interact with them using Web3 libraries or any compatible wallet that supports StarkNet.

```javascript
// Example of interacting with the locker contract
const lockerContract = new web3.eth.Contract(ABI, contractAddress);
await lockerContract.methods.lockLiquidity(amount).send({ from: senderAddress });
```

## Contributing

Contributions are welcome! We'll add guidelines later but pull requests, bug reports, and all other forms of contribution are welcomed and highly encouraged!