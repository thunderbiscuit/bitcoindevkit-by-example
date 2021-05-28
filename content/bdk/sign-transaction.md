---
layout: default
title: "Sign a Transaction"
parent: Rust
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 4
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk/sign-transaction
---
# Sign a Transaction
<br/>

```rust
use bdk::{Wallet, SignOptions, database::MemoryDatabase};

use bitcoin::consensus::deserialize;

fn main() -> Result<(), bdk::Error> {
    let wallet = Wallet::new_offline(
        "wpkh([c258d2e4/84h/1h/0h]tprv8griRPhA7342zfRyB6CqeKF8CJDXYu5pgnj1cjL1u2ngKcJha5jjTRimG82ABzJQ4MQe71CV54xfn25BbhCNfEGGJZnxvCDQCd6JkbvxW6h/0/*)",
        Some("wpkh([c258d2e4/84h/1h/0h]tprv8griRPhA7342zfRyB6CqeKF8CJDXYu5pgnj1cjL1u2ngKcJha5jjTRimG82ABzJQ4MQe71CV54xfn25BbhCNfEGGJZnxvCDQCd6JkbvxW6h/1/*)"),
        bitcoin::Network::Testnet,
        MemoryDatabase::default(),
    )?;

    let psbt = "...";
    let mut psbt = deserialize(&base64::decode(psbt).unwrap())?;

    let finalized = wallet.sign(&mut psbt, SignOptions::default())?;

    Ok(())
}
```
