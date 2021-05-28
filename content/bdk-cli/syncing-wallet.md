---
layout: default
title: "Syncing a Wallet"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 6
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/syncing-wallet
parent: "Command Line"
---
# Creating and Syncing a Wallet
<br/>

All wallet operations use the `wallet` subcommand. You sync your wallet to the blockchain with the appropriately named `sync` subcommand:
```sh
bdk-cli wallet --descriptor "wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)" sync  
```

When we give `bdk-cli` a descriptor, it creates a entry for us in a small [`sled`]() database located at `~/.bdk-bitcoin/` on our machine. This wallet does not actually contain the descriptor (hence the need to provide it at every command) but does keep track of a few things for you that make it convenient. Note that you can delete this database at any time without loosing anything that cannot be rebuilt by syncing back up.

This sort of "cache" has a default name of _main_, and if you try and give bdk a new command but with a different descriptor (say you want to test with multiple wallets at once), it will throw an error, since the new descriptor will not match the currently existing 'main' wallet in the database.

The way to play with multiple wallets at once is to name them as they are being created and used. The command above could be modified like so:

```sh
bdk-cli wallet --wallet "testwalletnumber1" --descriptor "wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)" sync  
```
which will create a wallet called `testwalletnumber1` in the database. If you are dealing with multiple wallets, you must provide the `--wallet` option every time, unless you wish to use the default wallet.  
