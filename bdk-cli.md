---
layout: default
title: "bdk-cli"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 2
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli
---

<div style="display: flex; justify-content: space-evenly; margin-top: 1rem;">
  <img src="./img/bash.svg" width="200">
  
  <div style="display: flex; align-items: center; justify-content: center;">
    <div>
      <h1>
        bdk-cli
      </h1>
      <p style="margin: 0 0 0.5em 0">
        <em>v0.1.1</em>
      </p>
      <a href="https://github.com/bitcoindevkit/bdk-cli">
        <h4>
          <em>Source</em>
        </h4>
      </a>
    </div>
  </div>

  <ol>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#basic-workflow">Basic Workflow</a></li>
    <li><a href="#using-the-manual-pages-help">Using the Man Pages</a></li>
    <li><a href="#map-of-subcommands">Map of Subcommands</a></li>
    <li><a href="#generating-new-keys">Generating New Keys</a></li>
    <li><a href="#example-wallet">Example Wallet</a></li>
    <li><a href="#creating-and-syncing-a-wallet">Creating and Syncing a Wallet</a></li>
    <li><a href="#receiving-coins">Receiving Coins</a></li>
    <li><a href="#sending-coins">Sending Coins</a></li>
    <li><a href="#building-a-2-of-2-multisig-transaction-using-psbts">Building a 2-of-2 multisig using PSBTs</a></li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</div>
<hr/>

## Getting Started
There are a few ways to use `bdk-cli`:

### 1. Building from source
By cloning the repo, building the library, and calling the resulting executable like so:

```sh
git clone https://github.com/bitcoindevkit/bdk-cli.git
cargo run -- wallet --descriptor "wpkh(tpubEBr4i6yk5nf5DAaJpsi9N2pPYBeJ7fZ5Z9rmN4977iYLCGco1VyjB9tvvuvYtfZzjD5A8igzgw3HeWeeKFmanHYqksqZXYXGsw5zjnj7KM9/*)" sync  
```
The first set of double dashes indicates to cargo that what follows are arguments to send to the executable.  

You can keep using bdk-cli this way (with `cargo run`), or you build from source and install the binaries so as to be able to use `bdk-cli` directly (as in #2 below). To build/install, use 
```sh
cargo install --path . --features repl,electrum,esplora
```

### 2. Installing the binary directly from crates.io
By installing the binaries directly from crates.io and calling the cli like so:

```sh
cargo install bdk-cli
bdk-cli wallet --descriptor "wpkh(tpubEBr4i6yk5nf5DAaJpsi9N2pPYBeJ7fZ5Z9rmN4977iYLCGco1VyjB9tvvuvYtfZzjD5A8igzgw3HeWeeKFmanHYqksqZXYXGsw5zjnj7KM9/*)" sync  
```

### 3. REPL
By entering the repl like this:

```sh
cargo install bdk-cli
bdk-cli repl --descriptor "wpkh(tpubEBr4i6yk5nf5DAaJpsi9N2pPYBeJ7fZ5Z9rmN4977iYLCGco1VyjB9tvvuvYtfZzjD5A8igzgw3HeWeeKFmanHYqksqZXYXGsw5zjnj7KM9/*)"  
```
The repl allows you to set the descriptor once and enter a read-eval-print-loop, where the cli tool will allow you to enter as many subcommands as you wish until you break out of the loop. It looks something like this:

```sh
bdk-cli repl --descriptor "wpkh(tpubEBr4i6yk5nf5DAaJpsi9N2pPYBeJ7fZ5Z9rmN4977iYLCGco1VyjB9tvvuvYtfZzjD5A8igzgw3HeWeeKFmanHYqksqZXYXGsw5zjnj7KM9/*)"  

>> sync
{}

>> list_transactions
[
  {
    "fees": 205,
    "height": 1903506,
    "received": 1580,
    "sent": 0,
    "timestamp": 1610371954,
    "transaction": null,
    "txid": "5a583f5f41eff6009a36bc0ad7fcbec494ac7f0719707dd4dd0f8fddbb3e0b26"
  }
]

>> get_new_address
{
  "address": "tb1q4er7kxx6sssz3q7qp7zsqsdx4erceahhax77d7"
}
```

## Basic Workflow
The basic workflow of `bdk-cli` looks like this: 
1. If you are using the cli, you provide a descriptor every time, followed by a subcommand 
```sh
bdk-cli wallet --descriptor "wpkh(tprv8Z...fQtF/84'/1'/0'/0/*)" sync
bdk-cli wallet --descriptor "wpkh(tprv8Z...fQtF/84'/1'/0'/0/*)" list_transactions
bdk-cli wallet --descriptor "wpkh(tprv8Z...fQtF/84'/1'/0'/0/*)" get_new_address
```
2. If you are using the repl, you provide a descriptor once (when entering the repl), and then as many subcommands as you want until you exit (but these subcommands can only apply to that one descriptor):
```sh
bdk-cli repl --descriptor "wpkh(tprv8Z...fQtF/84'/1'/0'/0/*)"
>> sync
>> list_transactions
>> get_new_address
```

## Using the Manual Pages (help)
You can get information about how to use `bdk-cli` by using
```sh
# cli
bdk-cli --help

# repl
>> help
```

You can also get additional information on specific commands and subcommands by adding them to the `help` subcommand like so: 
```sh
# cli
bdk-cli help list_transactions
bdk-cli help key generate

# repl
>> help list_transactions
```

or by using the `--help` or `-h` flag on any command and subcommand:
```sh
bdk-cli key --help
bdk-cli key restore --help
```

## Map of Subcommands
The whole tree of subcommands for bdk-cli can be mapped like so:

```shell
bdk-cli ---| help
           | repl
           | key ------| generate
                       | restore
           | wallet ---| broadcast
                       | bump_fee
                       | combine_psbt
                       | create_tx
                       | extract_psbt
                       | finalize_psbt
                       | get_balance
                       | get_new_address
                       | list_transactions
                       | list_unspent
                       | policies
                       | public_descriptor
                       | sign
                       | sync
```

## Generating New Keys
Generate a new extended master key suitable for using in a descriptor with
```sh
bdk-cli key generate --entropy 12
{
  "fingerprint": "2a0e129d",
  "mnemonic": "vocal fantasy gap lumber guess broom gate creek game coral rice flock",
  "xprv": "tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5",
  "xpub": "tpubD6NzVbkrYhZ4Y6WZ93Jt3iAgaDanZb1P9JYFHvjyrUbxjV61nbE7dZxaJYHYK29MrpLJKc7uKo1gTUhTHni21sgh4mT5p2Qs6pRXoXFFWzY"
}
```

This `xprv` master key can then be used to derive common BIP 39/44/84 wallets. For example the BIP84 receive and change wallet descriptors would be the following:
```sh
# receive wallet
wpkh(tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5/84'/1'/0'/0/*)  

# change wallet
wpkh(tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5/84'/1'/0'/1/*)  
```

You can restore keys from a mnemonic using the `restore` subcommand:
```sh
bdk-cli key restore --mnemonic "vocal fantasy gap lumber guess broom gate creek game coral rice flock"
```

## Example Wallet
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

## Creating and Syncing a Wallet
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

## Receiving coins
```sh
bdk-cli wallet --wallet bdk-by-example --descriptor "wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)" repl  

>> get_new_address
{
  "address": "tb1qa9tay78q3hc6470e4f7v3pmqukzrauvgcl7qjt"
}

>> list_transactions
[
  {
    "fees": 141,
    "height": null,
    "received": 10000,
    "sent": 0,
    "timestamp": 0,
    "transaction": null,
    "txid": "2b74aa4a0775162051f51d960ecc1b7e623d3d57d18fcfca7ea4d0e642f89918"
  }
]
```

## Sending coins
A simple send transaction is done using the following steps:
1. Create the transaction (`create_tx --to <address:sat>`)
2. Sign the psbt (`sign --psbt <psbt from step 1>`)
3. Broadcast the transaction (`broadcast --psbt <signed psbt from step 2>`)

The `create_tx` subcommand requires the `--to` flag with an argument in the format `address:sat`.

The example below performs that transaction using the repl. Note that when providing the psbts to the repl we do not enclose the psbt in quotation marks, whereas if we perform these commands using the normal cli we do need to put the psbts in quotes.

```sh
bdk-cli repl --wallet bdk-by-example --descriptor "wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)"

>> create_tx --to tb1qjpfm4vz5w2l0hzp2t0fd8esguxe08pntgv79vl:3232
{
  "details": {
    "fees": 141,
    "height": null,
    "received": 3042,
    "sent": 6415,
    "timestamp": 1611499836,
    "transaction": null,
    "txid": "f6ef8179b7612a272205bd152d8e833b6b9ced11aedbb2678eb9ba211157bb12"
  },
  "psbt": "cHNidP8BAHEBAAAAARAnt7YyE0GznP/9ddMvJj21UZJvYxePoPZzLKQaABqrAQAAAAD/////AuILAAAAAAAAFgAUR/J8qBUWz+VI4IPMZf9h4V2LbWmgDAAAAAAAABYAFJBTurBUcr77iCpb0tPmCOGy84ZrAAAAAAABAR8PGQAAAAAAABYAFEVWZq4wmchQmMHuTxXn5nJorLFiIgYD2buG/D7EDLZn7nsbD8JEpdDrJ//odPM1S6dLbxhwv7sY1n+6l1QAAIABAACAAAAAgAAAAAACAAAAACICA8EuowXeoqVzny4kvL5RrEiNBBDrKGQaXv7yEq+2ArrYGNZ/updUAACAAQAAgAAAAIAAAAAAAwAAAAAA"
}

>> sign --psbt cHNidP8BAHEBAAAAARAnt7YyE0GznP/9ddMvJj21UZJvYxePoPZzLKQaABqrAQAAAAD/////AuILAAAAAAAAFgAUR/J8qBUWz+VI4IPMZf9h4V2LbWmgDAAAAAAAABYAFJBTurBUcr77iCpb0tPmCOGy84ZrAAAAAAABAR8PGQAAAAAAABYAFEVWZq4wmchQmMHuTxXn5nJorLFiIgYD2buG/D7EDLZn7nsbD8JEpdDrJ//odPM1S6dLbxhwv7sY1n+6l1QAAIABAACAAAAAgAAAAAACAAAAACICA8EuowXeoqVzny4kvL5RrEiNBBDrKGQaXv7yEq+2ArrYGNZ/updUAACAAQAAgAAAAIAAAAAAAwAAAAAA
{
  "is_finalized": true,
  "psbt": "cHNidP8BAHEBAAAAARAnt7YyE0GznP/9ddMvJj21UZJvYxePoPZzLKQaABqrAQAAAAD/////
AuILAAAAAAAAFgAUR/J8qBUWz+VI4IPMZf9h4V2LbWmgDAAAAAAAABYAFJBTurBUcr77iCpb0tPmCOGy84ZrAAAAAAABAR8PGQAAAAAAABYAFEVWZq4wmchQmMHuTxXn5nJorLFiIgID2buG/D7EDLZn7nsbD8JEpdDrJ//odPM1S6dLbxhwv7tHMEQCICKsBcfLknBZ+Y7yYDoerrT63zuz6uXqtRMzTrNa0gEwAiBsyPsvcBYGbaZHFIgeC0WF4FTCPaSKynsWRsgBTfg5VAEiBgPZu4b8PsQMtmfuexsPwkSl0Osn/+h08zVLp0tvGHC/uxjWf7qXVAAAgAEAAIAAAACAAAAAAAIAAAABBwABCGsCRzBEAiAirAXHy5JwWfmO8mA6Hq60+t87s+rl6rUTM06zWtIBMAIgbMj7L3AWBm2mRxSIHgtFheBUwj2kisp7FkbIAU34OVQBIQPZu4b8PsQMtmfuexsPwkSl0Osn/+h08zVLp0tvGHC/uwAiAgPBLqMF3qKlc58uJLy+UaxIjQQQ6yhkGl7+8hKvtgK62BjWf7qXVAAAgAEAAIAAAACAAAAAAAMAAAAAAA=="
}

>> broadcast --psbt cHNidP8BAHEBAAAAARAnt7YyE0GznP/9ddMvJj21UZJvYxePoPZzLKQaABqrAQAAAAD/////AuILAAAAAAAAFgAUR/J8qBUWz+VI4IPMZf9h4V2LbWmgDAAAAAAAABYAFJBTurBUcr77iCpb0tPmCOGy84ZrAAAAAAABAR8PGQAAAAAAABYAFEVWZq4wmchQmMHuTxXn5nJorLFiIgID2buG/D7EDLZn7nsbD8JEpdDrJ//odPM1S6dLbxhwv7tHMEQCICKsBcfLknBZ+Y7yYDoerrT63zuz6uXqtRMzTrNa0gEwAiBsyPsvcBYGbaZHFIgeC0WF4FTCPaSKynsWRsgBTfg5VAEiBgPZu4b8PsQMtmfuexsPwkSl0Osn/+h08zVLp0tvGHC/uxjWf7qXVAAAgAEAAIAAAACAAAAAAAIAAAABBwABCGsCRzBEAiAirAXHy5JwWfmO8mA6Hq60+t87s+rl6rUTM06zWtIBMAIgbMj7L3AWBm2mRxSIHgtFheBUwj2kisp7FkbIAU34OVQBIQPZu4b8PsQMtmfuexsPwkSl0Osn/+h08zVLp0tvGHC/uwAiAgPBLqMF3qKlc58uJLy+UaxIjQQQ6yhkGl7+8hKvtgK62BjWf7qXVAAAgAEAAIAAAACAAAAAAAMAAAAAAA==
{
  "txid": "f6ef8179b7612a272205bd152d8e833b6b9ced11aedbb2678eb9ba211157bb12"
}
```

## Building a 2-of-2 multisig transaction using PSBTs
The worflow for this is the following:
1. Create individual wallets for all parties
2. Create descriptor for the "common" wallet which will generate both receive addresses and enable signatures
3. Create the initial unsigned Partially Signed Bitcoin Transaction (PSBT)
4. Pass that psbt to Alice so she can sign it and produce an updated psbt
5. Pass that new psbt to Bob so he can sign it as well
6. Finalize the psbt
7. Broadcast the transaction to the network

First, let's build our wallets.
```sh
# Alice
bdk-cli key generate --entropy 24
{
  "fingerprint": "6926972a",
  "mnemonic": "pulp clinic battle blast crumble tube orphan jungle eye swing vessel save like club situate dash female august wall danger street there embrace robot",
  "xprv": "tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B"
}

# Create xpub descriptor wallet for Alice
bdk-cli wallet --descriptor "wpkh(tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*)" public_descriptor
{
  "external": "wpkh([6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*)#ymtz0gs6",
  "internal": null
}

# Bob
bdk-cli key generate --entropy 24
{
  "fingerprint": "a0ff6e5d",
  "mnemonic": "mistake hidden pull together affair card easily shell stumble wolf leisure swamp stamp error appear bachelor meat split negative feature slush disagree food control",
  "xprv": "tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR"
}

# Create xpub descriptor wallet for Bob
bdk-cli wallet --descriptor "wpkh(tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*)" public_descriptor
{
  "external": "wpkh([a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*)#3fsvszk3",
  "internal": null
}
```

Next, we need a public descriptor for the common wallet between Alice and Bob. The descriptors for these types of wallets often use miniscript, and so you'll often need to find the exact miniscript needed for the type of locking script you wish to impose on the addresses your wallet will generate. Once place to do that is in the [playground](https://bitcoindevkit.org/bdk-cli/playground/) on the bitcoindevkit website. Here we want a 2-of-2 multisig, which actually not to miniscript but to a simpler Pay to Witness Script Hash: `wsh(multi(2,Alice,Bob))`. We'll start by building 3 versions of the wallet descriptors: a public one consisting of Alice and Bob's `xpub`s, one where Alice has her `xprv` but doesn't know Bob's `xprv`, and a third one where Bob has Alice's `xpub` and his `xprv`.
```sh
# wsh(multi(2,Alice,Bob))
# descriptor for the public wallet (no xprv)
"wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))"

# Alice's private version of the descriptor
"wsh(multi(2,tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))"

# Bob's private version of the descriptor
"wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*))"
```

From here we have all we need to generate the PSBTs and sign them. To generate receive addresses and construct the unsigned empty initial PSBT, all we need is the public version of the wallet, and so that's what we'll derive here:
```sh
# build common public wallet for multisig and generate receive address
# note that this would have been the same address had we build the wallet using any of the 2 other descriptors above
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" get_new_address
{
  "address": "tb1qnvqrz66zce2c8mxeajjv3hfwnu2sehf5rjcg4m27lftphu3rtlnqrvgsmt"
}

# *Send testnet coins to address above to fund the wallet and verify they have confirmed
# txid: 73a2aae654ce4176bb387e58b838682057be59fc69f8749279f4de5e062300b6

# Generate unsigned PSBT
# ***At this point we need the wallet to be funded and synced!***
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" create_tx --to "tb1qm5tfegjevj27yvvna9elym9lnzcf0zraxgl8z2:0" --send_all
{
  "details": {
    "fees": 138,
    "height": null,
    "received": 0,
    "sent": 10000,
    "timestamp": 1613703354,
    "transaction": null,
    "txid": "948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d"
  },
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
}
```

We now have an unsigned PSBT ready to be passed around to the signators. Alice takes the first round and signs using her private wallet. This is a different descriptor than in the previous step, so you'll either need to delete your bdk cache (`rm -rf ~/.bdk-bitcoin/`) or name your wallets (see examples in previous sections for how to do just that).
```sh
# Round 1: Alice signs the psbt
# ***Make sure Alice's new wallet is synced!***
bdk-cli wallet --descriptor "wsh(multi(2,tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" sign --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
{
  "is_finalized": false,
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
}
# notice how the psbt is now bigger than it was before Alice signed it

# Bob signs the psbt
# ***Make sure Bob's wallet is synced!***
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*))" sign --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
{
  "is_finalized": true,
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEiAgMV4rEqjWUqld8xndQ0doAo0IL4eR0TwTmST0Sl/XKV2UgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAEHAAEI3AQASDBFAiEAiDbsBfw75s+XuxAT9qQTOOPSeBQuuUOohRI1cfCRJ/ECIHe+UF2gGo0gCehMOFWRNPQj3OiJa/r5uxhY0ythZLwYAUgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAFHUiECYR0rgAuDh6HF83kNFUlUI2kLsa705pG+s9HNN3vHDuohAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZUq4AAA=="
}
```

Note that the returned object on the last signature shows the `is_finalized` key as `true`. This means the psbt is ready to be broadcast.
```sh
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" broadcast --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEiAgMV4rEqjWUqld8xndQ0doAo0IL4eR0TwTmST0Sl/XKV2UgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAEHAAEI3AQASDBFAiEAiDbsBfw75s+XuxAT9qQTOOPSeBQuuUOohRI1cfCRJ/ECIHe+UF2gGo0gCehMOFWRNPQj3OiJa/r5uxhY0ythZLwYAUgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAFHUiECYR0rgAuDh6HF83kNFUlUI2kLsa705pG+s9HNN3vHDuohAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZUq4AAA=="
{
  "txid": "948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d"
}
```

That's it! You can see the final transaction [here](https://blockstream.info/testnet/tx/948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d).

## Contributing
If you think this section could use a fix or additional content, we'd love to hear about it! Feel free to open an issue or a pull request [here](https://github.com/thunderbiscuit/bitcoindevkit-by-example).

<script>
const toggleDarkMode = document.querySelector('.js-toggle-dark-mode');

jtd.addEvent(toggleDarkMode, 'click', function(){
  if (jtd.getTheme() === 'dark') {
    jtd.setTheme('light');
    toggleDarkMode.textContent = 'Come to the dark side';
  } else {
    jtd.setTheme('dark');
    toggleDarkMode.textContent = 'Return to the light side';
  }
});
</script>
