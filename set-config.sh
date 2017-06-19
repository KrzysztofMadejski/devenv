#!/bin/bash

repo="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TODO ln
cp -i $repo/config/.* ~/
mkdir -p ~/.config/git
mv ~/.git.ignore ~/.config/git/ignore

echo ". ~/.bashrc.ext" >> ~/.bashrc


