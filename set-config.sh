#!/bin/bash

repo="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TODO ln
cp -i $repo/config/.* ~/

echo ". ~/.bashrc.ext" >> ~/.bashrc


