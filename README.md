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
