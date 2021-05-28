---
layout: default
title: "Receiving Coins"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 7
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/receiving-coins
parent: "Command Line"
---
# Receiving coins
<br/>

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
