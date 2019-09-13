#!/usr/bin/env bash

wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz

function on_startup {
    # Save to startup file and enable
    echo $1 >> ~/.bashrc
    `$1`
}

on_startup 'export PATH=$PATH:/usr/local/go/bin'

