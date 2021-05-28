---
layout: default
title: "Multisignature"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 8
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk-cli/multisig
parent: "Command Line"
---
# Building a 2-of-2 multisig transaction using PSBTs
<br/>

The worflow for this is the following:
1. Create individual wallets for all parties
2. Create descriptor for the "common" wallet which will generate both receive addresses and enable signatures
3. Create the initial unsigned Partially Signed Bitcoin Transaction (PSBT)
4. Pass that psbt to Alice so she can sign it and produce an updated psbt
5. Pass that new psbt to Bob so he can sign it as well
6. Finalize the psbt
7. Broadcast the transaction to the network

First, let's build our wallets.
```sh
# Alice
bdk-cli key generate --entropy 24
{
  "fingerprint": "6926972a",
  "mnemonic": "pulp clinic battle blast crumble tube orphan jungle eye swing vessel save like club situate dash female august wall danger street there embrace robot",
  "xprv": "tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B"
}

# Create xpub descriptor wallet for Alice
bdk-cli wallet --descriptor "wpkh(tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*)" public_descriptor
{
  "external": "wpkh([6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*)#ymtz0gs6",
  "internal": null
}

# Bob
bdk-cli key generate --entropy 24
{
  "fingerprint": "a0ff6e5d",
  "mnemonic": "mistake hidden pull together affair card easily shell stumble wolf leisure swamp stamp error appear bachelor meat split negative feature slush disagree food control",
  "xprv": "tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR"
}

# Create xpub descriptor wallet for Bob
bdk-cli wallet --descriptor "wpkh(tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*)" public_descriptor
{
  "external": "wpkh([a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*)#3fsvszk3",
  "internal": null
}
```

Next, we need a public descriptor for the common wallet between Alice and Bob. The descriptors for these types of wallets often use miniscript, and so you'll often need to find the exact miniscript needed for the type of locking script you wish to impose on the addresses your wallet will generate. Once place to do that is in the [playground](https://bitcoindevkit.org/bdk-cli/playground/) on the bitcoindevkit website. Here we want a 2-of-2 multisig, which actually not to miniscript but to a simpler Pay to Witness Script Hash: `wsh(multi(2,Alice,Bob))`. We'll start by building 3 versions of the wallet descriptors: a public one consisting of Alice and Bob's `xpub`s, one where Alice has her `xprv` but doesn't know Bob's `xprv`, and a third one where Bob has Alice's `xpub` and his `xprv`.
```sh
# wsh(multi(2,Alice,Bob))
# descriptor for the public wallet (no xprv)
"wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))"

# Alice's private version of the descriptor
"wsh(multi(2,tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))"

# Bob's private version of the descriptor
"wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*))"
```

From here we have all we need to generate the PSBTs and sign them. To generate receive addresses and construct the unsigned empty initial PSBT, all we need is the public version of the wallet, and so that's what we'll derive here:
```sh
# build common public wallet for multisig and generate receive address
# note that this would have been the same address had we build the wallet using any of the 2 other descriptors above
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" get_new_address
{
  "address": "tb1qnvqrz66zce2c8mxeajjv3hfwnu2sehf5rjcg4m27lftphu3rtlnqrvgsmt"
}

# *Send testnet coins to address above to fund the wallet and verify they have confirmed
# txid: 73a2aae654ce4176bb387e58b838682057be59fc69f8749279f4de5e062300b6

# Generate unsigned PSBT
# ***At this point we need the wallet to be funded and synced!***
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" create_tx --to "tb1qm5tfegjevj27yvvna9elym9lnzcf0zraxgl8z2:0" --send_all
{
  "details": {
    "fees": 138,
    "height": null,
    "received": 0,
    "sent": 10000,
    "timestamp": 1613703354,
    "transaction": null,
    "txid": "948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d"
  },
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
}
```

We now have an unsigned PSBT ready to be passed around to the signators. Alice takes the first round and signs using her private wallet. This is a different descriptor than in the previous step, so you'll either need to delete your bdk cache (`rm -rf ~/.bdk-bitcoin/`) or name your wallets (see examples in previous sections for how to do just that).
```sh
# Round 1: Alice signs the psbt
# ***Make sure Alice's new wallet is synced!***
bdk-cli wallet --descriptor "wsh(multi(2,tprv8ZgxMBicQKsPeG1VL2QFVJKtXJUGhRMUR5oZkqhNnd6GeX671mZTkfz9omTyVHvoZ6WnmectqWf1Lz4FLXmqnohpyg7HD7Lt6BavNkTAt6B/84h/1h/0h/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" sign --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
{
  "is_finalized": false,
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
}
# notice how the psbt is now bigger than it was before Alice signed it

# Bob signs the psbt
# ***Make sure Bob's wallet is synced!***
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,tprv8ZgxMBicQKsPfFrtXpphYa3nrKfZEQK7UxQJi4oGWXAfhnhuFPa59R628kpptohy3qPsrjNpoVjfDhS8bcf2qdpgnwd4AdzrknrCCv8NSwR/84h/1h/0h/0/*))" sign --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAAA"
{
  "is_finalized": true,
  "psbt": "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEiAgMV4rEqjWUqld8xndQ0doAo0IL4eR0TwTmST0Sl/XKV2UgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAEHAAEI3AQASDBFAiEAiDbsBfw75s+XuxAT9qQTOOPSeBQuuUOohRI1cfCRJ/ECIHe+UF2gGo0gCehMOFWRNPQj3OiJa/r5uxhY0ythZLwYAUgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAFHUiECYR0rgAuDh6HF83kNFUlUI2kLsa705pG+s9HNN3vHDuohAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZUq4AAA=="
}
```

Note that the returned object on the last signature shows the `is_finalized` key as `true`. This means the psbt is ready to be broadcast.
```sh
bdk-cli wallet --descriptor "wsh(multi(2,[6926972a/84'/1'/0']tpubDCj3FLoMDHpcfex7esm3hRw5xie6jDzrKpdJ4mLD95wZLdUHXoiw9tJAamG7gaTJb4yiLyGAAKwQah8c2yAoyR5UXtyY6xW3n8vNoWZMmdM/0/*,[a0ff6e5d/84'/1'/0']tpubDCqapM5b7JtmYwt1tcnPnk5e5Wqw6FKYsz1PutkRvmA6G653sCjFr4Qdhncgd4xTmG7BQgJtFkPCxP3jsS7byPUnDaS5FD3Ad7qoEfiamMe/0/*))" broadcast --psbt "cHNidP8BAFIBAAAAAbYAIwZe3vR5knT4afxZvlcgaDi4WH44u3ZBzlTmqqJzAQAAAAD/////AYYmAAAAAAAAFgAU3RacollkleIxk+lz8my/mLCXiH0AAAAAAAEBKxAnAAAAAAAAIgAgmwAxa0LGVYPs2eykyN0unxUM3TQcsIrtXvpWG/IjX+YiAgJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6kgwRQIhAIg27AX8O+bPl7sQE/akEzjj0ngULrlDqIUSNXHwkSfxAiB3vlBdoBqNIAnoTDhVkTT0I9zoiWv6+bsYWNMrYWS8GAEiAgMV4rEqjWUqld8xndQ0doAo0IL4eR0TwTmST0Sl/XKV2UgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAEBBUdSIQJhHSuAC4OHocXzeQ0VSVQjaQuxrvTmkb6z0c03e8cO6iEDFeKxKo1lKpXfMZ3UNHaAKNCC+HkdE8E5kk9Epf1yldlSriIGAmEdK4ALg4ehxfN5DRVJVCNpC7Gu9OaRvrPRzTd7xw7qGGkmlypUAACAAQAAgAAAAIAAAAAAAAAAACIGAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZGKD/bl1UAACAAQAAgAAAAIAAAAAAAAAAAAEHAAEI3AQASDBFAiEAiDbsBfw75s+XuxAT9qQTOOPSeBQuuUOohRI1cfCRJ/ECIHe+UF2gGo0gCehMOFWRNPQj3OiJa/r5uxhY0ythZLwYAUgwRQIhAPrrKo7eUj//y2d/q0ewMuPxlJcXPWNYqdKzDTq//g6BAiBS47nKqoxInyAx0k14yH+PGq3MpCjH01AOde9n7chnlAFHUiECYR0rgAuDh6HF83kNFUlUI2kLsa705pG+s9HNN3vHDuohAxXisSqNZSqV3zGd1DR2gCjQgvh5HRPBOZJPRKX9cpXZUq4AAA=="
{
  "txid": "948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d"
}
```

That's it! You can see the final transaction [here](https://blockstream.info/testnet/tx/948b6d5220043c1343f5569c35c5b33ab7b6159e9c8da5edd0f160a8c711f25d).

## Contribute
If you think this page could use a fix or some additional content, we'd love to hear about it! Feel free to open an issue or a pull request [here](https://github.com/thunderbiscuit/bitcoindevkit-by-example).

<script>
const toggleDarkMode = document.querySelector('.js-toggle-dark-mode');

jtd.addEvent(toggleDarkMode, 'click', function(){
  if (jtd.getTheme() === 'dark') {
    document.getElementById("cli-logo").src="./img/bash-light.svg";
    jtd.setTheme('light');
    toggleDarkMode.textContent = 'Come to the dark side';
  } else {
    document.getElementById("cli-logo").src="./img/bash-dark.svg";
    jtd.setTheme('dark');
    toggleDarkMode.textContent = 'Return to the light side';
  }
});
</script>
