#!/usr/bin/env sh

# abort on errors
set -e

# build
jekyll build

# navigate into the build output directory
cd _site

git init
git add -A
git commit -m "deploy"

git push -f git@github.com:thunderbiscuit/bitcoindevkit-by-example.git master:website

cd -
