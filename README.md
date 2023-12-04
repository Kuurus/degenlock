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

sncast --url http://localhost:5050/rpc account add --name test1 --address 0x1078ebdce158d895f54a0c35c00e1de17401ca76e5d6f5f14845bd556dfee2f --private-key 0x64e8ab7b9a3b2284ed0f83d2a8f2d300 --add-profile

## DECLARE CONTRACT

sudo sncast --url http://localhost:5050/rpc declare --contract-name HelloStarknet

Return class_hash and transaction_hash
class_hash : 0x6ea4e9644444cbbb9367da2b42d94628dd70af6e2cc8a2c29405b328d114c38

## DEPLOY CONTRACT

sudo sncast --url http://localhost:5050/rpc deploy --class-hash 0x6ea4e9644444cbbb9367da2b42d94628dd70af6e2cc8a2c29405b328d114c38

Returns contract_address and transaction_hash

## Invoke function

sncast invoke --contract-address 0xaa10c2dd546af620995e4596842ceaa3b0fc52ae4a9fba84a7b8af5953d66c --function deploy_contract --calldata 0x6ea4e9644444cbbb9367da2b42d94628dd70af6e2cc8a2c29405b328d114c38 1
