---
layout: default
title: "Generating new keys"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 5
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/generating-new-keys
parent: "Command Line"
---
## Generating New Keys
Generate a new extended master key suitable for using in a descriptor with
```sh
bdk-cli key generate --entropy 12
{
  "fingerprint": "2a0e129d",
  "mnemonic": "vocal fantasy gap lumber guess broom gate creek game coral rice flock",
  "xprv": "tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5",
  "xpub": "tpubD6NzVbkrYhZ4Y6WZ93Jt3iAgaDanZb1P9JYFHvjyrUbxjV61nbE7dZxaJYHYK29MrpLJKc7uKo1gTUhTHni21sgh4mT5p2Qs6pRXoXFFWzY"
}
```

This `xprv` master key can then be used to derive common BIP 39/44/84 wallets. For example the BIP84 receive and change wallet descriptors would be the following:
```sh
# receive wallet
wpkh(tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5/84'/1'/0'/0/*)  

# change wallet
wpkh(tprv8ZgxMBicQKsPedUmFPeHeJWa1C4rQFpUZzwU1QhgSCoZtzqFACQXT5Li8NQLRH1syNVi3iZi5PUUGkTDGXV1CUpeusLxf77Xzm969Ur8uy5/84'/1'/0'/1/*)  
```

You can restore keys from a mnemonic using the `restore` subcommand:
```sh
bdk-cli key restore --mnemonic "vocal fantasy gap lumber guess broom gate creek game coral rice flock"
```
