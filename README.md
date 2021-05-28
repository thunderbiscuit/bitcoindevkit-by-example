# Bitcoindevkit by Example 😎

[Check it out](https://thunderbiscuit.github.io/bitcoindevkit-by-example)!

I initially wrote this for myself, but I will gladly merge PRs for more content!

## Build locally
This website uses Jekyll, a static site generator, coupled with the simple yet very clean [just-the-docs theme](https://pmarsceill.github.io/just-the-docs/). 

The theme documentation has all the info you need to build locally and customize the theme, but the simple way to build locally for testing and content development is to ensure you have the Ruby toolchain with Jekyll available and simply run
```sh
git clone https://github.com/thunderbiscuit/bitcoindevkit-by-example.git
cd bitcoindevkit-by-example
jekyll serve
```

Changes to the markdown files in the `content` directory will be reflected immediatly on `localhost:4000/`.
