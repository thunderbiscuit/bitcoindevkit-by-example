---
layout: default
title: "Basic Workflow"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 2
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/basic-workflow
parent: "Command Line"
---
# Basic Workflow
<br/>

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
