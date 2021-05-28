---
layout: default
title: "Using the Man Pages"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 3
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/man-pages
parent: "Command Line"
---
# Using the Manual Pages (help)
<br/>
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
