---
layout: default
title: "bdk"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 2
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk
---

<div style="display: flex; justify-content: space-evenly; margin-top: 1rem;">
  
  <!-- logo -->
  <img src="./img/rust.svg" width="200">
  
  <!-- metadata -->
  <div style="display: flex; align-items: center; justify-content: center;">
    <div>
      <h1>
        bdk
      </h1>
      <p style="margin: 0 0 0.5em 0">
        <em>v0.6.0</em>
      </p>
      <a href="https://github.com/bitcoindevkit/bdk">
        <h4>
          <em>Source</em>
        </h4>
      </a>
    </div>
  </div>

  <!-- table of content -->
  <ol>
    <li><a href="#sync-the-balance-of-a-descriptor">Sync Balance of Descriptor</a></li>
    <li><a href="#generate-a-few-addresses">Generate Addresses</a></li>
    <li><a href="#create-a-transaction">Create a Transaction</a></li>
    <li><a href="#sign-a-transaction">Sign a Transaction</a></li>
    <li><a href="#contributing">Contribute</a></li>
  </ol>
</div>
<hr/>

This section is under construction! Feel free to open a PR [here](https://github.com/thunderbiscuit/bitcoindevkit-by-example).

## Sync the balance of a descriptor
```rust,no_run
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

## Generate a few addresses
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

## Create a transaction
```rust,no_run
use bdk::{FeeRate, Wallet};
use bdk::database::MemoryDatabase;
use bdk::blockchain::{noop_progress, ElectrumBlockchain};

use bdk::electrum_client::Client;
use bdk::wallet::AddressIndex::New;

use bitcoin::consensus::serialize;

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

    let send_to = wallet.get_address(New)?;
    let (psbt, details) = {
        let mut builder = wallet.build_tx();
        builder
            .add_recipient(send_to.script_pubkey(), 50_000)
            .enable_rbf()
            .do_not_spend_change()
            .fee_rate(FeeRate::from_sat_per_vb(5.0));
        builder.finish()?
    };

    println!("Transaction details: {:#?}", details);
    println!("Unsigned PSBT: {}", base64::encode(&serialize(&psbt)));

    Ok(())
}
```

## Sign a transaction
```rust,no_run
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

## Contribute
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
