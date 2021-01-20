---
layout: default
title: bdk-cli
nav_order: 2
parent: bdk-cli
---

# bdk-cli  

<br/>

The examples below make use of the following testnet BIP84 wallet:
```
damage urban exercise recipe company execute ship damage offer point cereal exclude
```

Using [Ian Coleman's online tool](https://iancoleman.io/bip39/), we find that the BIP32 root key for the mnemonic backup is
```
tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF
```

This means the descriptor for a BIP84 bitcoin testnet wallet, account 0, receive addresses would be:
```sh
wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)
```

## Basics

```sh
bdk-cli --descriptor "wpkh(tprv8ZgxMBicQKsPdTayefG3Up8B1Rq3AwqQDfvEjt6oJCCwse3s79er2hYn8erb4rTgddL55SGKa8TjkoytzZXc7Kj4BLZwu2rzCFbE1KMfQtF/84'/1'/0'/0/*)" sync
```
