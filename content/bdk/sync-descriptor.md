---
layout: default
title: "Sync Balance of Descriptor"
parent: Rust
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 1
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk/sync-descriptor
---
# Sync the balance of a descriptor
<br/>

```rust
use bdk::Wallet;
use bdk::database::MemoryDatabase;
use bdk::blockchain::{noop_progress, ElectrumBlockchain};

use bdk::electrum_client::Client;

fn main() -> Result<(), bdk::Error> {
    let client = Client::new("ssl://electrum.blockstream.info:60002")?;
    let wallet = Wallet::new(
        "wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/0/*)",
        Some("wpkh([c258d2e4/84h/1h/0h]tpubDDYkZojQFQjht8Tm4jsS3iuEmKjTiEGjG6KnuFNKKJb5A6ZUCUZKdvLdSDWofKi4ToRCwb9poe1XdqfUnP4jaJjCB2Zwv11ZLgSbnZSNecE/1/*)"),
        bitcoin::Network::Testnet,
        MemoryDatabase::default(),
        ElectrumBlockchain::from(client)
    )?;

    wallet.sync(noop_progress(), None)?;

    println!("Descriptor balance: {} SAT", wallet.get_balance()?);

    Ok(())
}
```
