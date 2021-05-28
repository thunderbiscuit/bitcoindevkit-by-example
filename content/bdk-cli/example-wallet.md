---
layout: default
title: "Example Wallet"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 5
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/example-wallet
parent: "Command Line"
---
# Example Wallet
<br/>

The examples below make use of the following _testnet_ BIP84 wallet:
```
damage urban exercise recipe company execute ship damage offer point cereal exclude
```

Using the `restore` command, we find that the `xprv` for the wallet is
```
tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF
```

This means the descriptor for a BIP84 bitcoin testnet, account 0, series of receive addresses is:
```sh
wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)
```
