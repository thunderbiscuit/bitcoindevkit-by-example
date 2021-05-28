---
layout: default
title: "Generate Addresses"
parent: Rust
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 2
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk/generate-addresses
---
# Generate a few addresses
<br/>

```rust
use bdk::{Wallet, database::MemoryDatabase};
use bdk::wallet::AddressIndex::New;

fn main() -> Result<(), bdk::Error> {
    let wallet = Wallet::new_offline(
        "wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/0/*)",
        Some("wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/1/*)"),
        bitcoin::Network::Testnet,
        MemoryDatabase::default(),
    )?;

    println!("Address #0: {}", wallet.get_address(New)?);
    println!("Address #1: {}", wallet.get_address(New)?);
    println!("Address #2: {}", wallet.get_address(New)?);

    Ok(())
}
```
