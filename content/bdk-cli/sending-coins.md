---
layout: default
title: "Sending Coins"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 8
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/sending-coins
parent: "Command Line"
---
# Sending coins
<br/>

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
