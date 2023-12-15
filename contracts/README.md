# Starknet Forge Template

This repository is a basic project for Starknet Forge - testing tool that is a part of Starknet Foundry.

## Running `snforge`

Simply `snforge test` command in you terminal

## GitHub Action

The `.github/workflows/checks.yml` file contains example workflow utilizing
https://github.com/marketplace/actions/setup-starknet-foundry and https://github.com/marketplace/actions/setup-scarb
actions.

Use it as a starting point for setting up checks for your own Starknet Foundry project.

## Factory deploy syscall example :

https://github.com/OpenZeppelin/cairo-contracts/blob/f3e2a5f0547a429c716f32471b06df729cbdfb9f/src/tests/utils.cairo#L8

or

https://github.com/snapshot-labs/sx-starknet/blob/49e42850c808fea30e9fb5da5408478fee7ac680/starknet/src/factory/factory.cairo#L49C12-L49C12

## RUN devnet

see https://github.com/0xSpaceShard/starknet-devnet-rs

-> cargo run
RPC url - 127.0.0.1:5050
Required : url in scarb.toml

## ADD ACCOUNT

sncast --url http://localhost:5050/rpc account add --name te --address 0x481f4c22dee0790213876dfc311a7e544bc57be3165306fe680f7e72d9d3ba4 --private-key 0xb36c8b77e8056b7af35da7e6b236c7cc --add-profile

sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6 account add --name testnet --address 0x03d4eb3484ea8a9f388daecd48b0495c55d5c90203b4d5c40433ede24fa3aed0 --private-key 0x07544f68099ec1887008fba09192e8d8a55a1ff94f7ac4e7d1bfb1fb26fed8de --add-profile

## DECLARE CONTRACT

sudo sncast --url http://localhost:5050/rpc declare --contract-name HelloStarknet
sudo sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6 declare --contract-name HelloStarknet
Return class_hash and transaction_hash
class_hash : 0x6ea4e9644444cbbb9367da2b42d94628dd70af6e2cc8a2c29405b328d114c38

## DEPLOY CONTRACT

sudo sncast --url http://localhost:5050/rpc deploy --class-hash 0x4d49b78b388fce5a5557199d00a486648c9154d8412d235664112bb0e4e5b8
sudo sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6  
Returns contract_address and transaction_hash

## Invoke function

sncast invoke --contract-address 0xaa10c2dd546af620995e4596842ceaa3b0fc52ae4a9fba84a7b8af5953d66c --function deploy_contract --calldata 0x6ea4e9644444cbbb9367da2b42d94628dd70af6e2cc8a2c29405b328d114c38 1

https://cloud.argent-api.com/v1/starknet/goerli/rpc/v0.4
0x003000Db3F38FF0db2c5E41230Bfa3311Dad3f114D6D4140bCb515Ea0e31a901
0x07f303fe141458811ae5ec78d154caa07a3fe4b108b159cf970fb754fc7ba042

sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6 declare --contract-name HelloStarknet

sudo sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6 deploy --class-hash 0x4d49b78b388fce5a5557199d00a486648c9154d8412d235664112bb0e4e5b8
0x02479d6431f3aaa15c01f0bbdf9d05da7852069903a74d438286c74dc79a769b

0x4d49b78b388fce5a5557199d00a486648c9154d8412d235664112bb0e4e5b8

sudo sncast --url https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6 declare --contract-name HelloStarknet
