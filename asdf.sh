#!/usr/bin/env bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf
(cd ~/.asdf && git checkout "$(git describe --abbrev=0 --tags)")

function on_startup {
    # Save to startup file and enable
    echo $1 >> ~/.bashrc
    `$1`
}

on_startup ". $HOME/.asdf/asdf.sh"
on_startup ". $HOME/.asdf/completions/asdf.bash"

