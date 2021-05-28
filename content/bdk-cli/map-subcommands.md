---
layout: default
title: "Map of Subcommands"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 4
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/map-subcommands
parent: "Command Line"
---
# Map of Subcommands
<br/>
The whole tree of subcommands for bdk-cli can be mapped like so:

```shell
bdk-cli ---| help
           | repl
           | key ------| help
                       | generate
                       | restore
                       | derive
           | wallet ---| help
                       | broadcast
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
