---
layout: default
title: "Getting Started"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 1
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/getting-started
parent: "Command Line"
---
# Getting Started
<br/>
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
<br/>

### 2. Installing the binary directly from crates.io
By installing the binaries directly from crates.io and calling the cli like so:

```sh
cargo install bdk-cli
bdk-cli wallet --descriptor "wpkh(tpubEBr4i6yk5nf5DAaJpsi9N2pPYBeJ7fZ5Z9rmN4977iYLCGco1VyjB9tvvuvYtfZzjD5A8igzgw3HeWeeKFmanHYqksqZXYXGsw5zjnj7KM9/*)" sync  
```
<br/>

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
