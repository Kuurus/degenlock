# Basic Sample Cairo1 Hardhat Project - with Starknet Plugin

This project demonstrates a basic Hardhat project, but with [Starknet plugin](https://github.com/0xSpaceShard/starknet-hardhat-plugin).

## Get started

#### Clone this repo

```bash
git clone https://github.com/sustia-llc/cairo1-hardhat.git
cairo1-hardhat
```

#### Install dependencies

```bash
npm ci
```

#### Compile a Cairo1 contract

```bash
npx hardhat run scripts/compile-contract.ts
```

### Set up environment variables

Some scripts require environment variables (search for usage of `ensureEnvVar` in the repo). You can define these variables in an `.env` file in the project root. If you want to use the OZ devnet accounts in env.example, uncomment "--seed", "42", in the `hardhat.config.ts` file.

```bash
cp .env.example .env
```

## Run a test on integrated-devnet that interacts with the compiled Cairo1 contract

Set default network in `hardhat.config.ts` to `integrated-devnet`, then execute:

```bash
npm test
```

## Deploy the Cairo1 contract to devnet

Update version of the docker image by looking at the https://github.com/0xSpaceShard/starknet-hardhat-plugin

updgraded to starknet-devnet:0.5.0a1 with fix: https://github.com/0xSpaceShard/starknet-devnet/pull/426

```bash
sudo docker pull shardlabs/starknet-devnet:0.5.0a1
sudo docker run -p 5050:5050 shardlabs/starknet-devnet:0.5.0a1 --seed 42
```

Declare and deploy the contract to devnet:

Set `DEPLOYACCT_ADDRESS` and `DEPLOYACCT_PRIVATE_KEY` in `.env` file. Set starknet network in `hardhat.config.ts` to `devnet`, then execute:

```bash
npx hardhat run scripts/deploy.ts
```

Copy the contract address to the dapp

## Deploy the Cairo1 contract to devnet

Set `DEPLOYACCT_ADDRESS` and `DEPLOYACCT_PRIVATE_KEY` in `.env` file. Set starknet network in `hardhat.config.ts` to `alphaGoerli`, then execute:

Doesn't currently work:
~~npx hardhat run scripts/deploy.ts~~

```bash
source ~/starknet/test/venv/bin/activate
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
starknet declare --contract starknet-artifacts/cairo1-contracts/cairo1.cairo/cairo1.json --account v0.11.0.2
```

contract class hash:
0x2815ce967ef506c7db0dfc0bf3d6d83614bc5ecf11f7d592c87bbd6865c7392

```bash
starknet deploy --class_hash 0x2815ce967ef506c7db0dfc0bf3d6d83614bc5ecf11f7d592c87bbd6865c7392 --account v0.11.0.2 --inputs 0
```

contract address:
0x028ce960c0662945668e53f96b122ac9a2a5cdf88c03d20a785dc1c8b8329f5e

Copy the contract address to the dapp in src/features/counter/counterSlice.ts

## TODO

-   Review this as relates to deploy.ts on alphaGoerli https://github.com/0xs34n/starknet.js/issues/473
-   How to use ~/.starknet_accounts in hardhat.config.ts
-   Pass in --network or HARDHAT_NETWORK instead of changing hardhat.config.ts

```bash
HARDHAT_NETWORK=devnet node --require hardhat/register scripts/deploy.ts
```

npx hardhat run scripts/compile-contract.ts

npm test
