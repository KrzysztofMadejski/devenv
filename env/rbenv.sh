#!/bin/bash

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
PATH="$HOME/.rbenv/bin:$PATH"

# Assuming bash, for other shells run: ~/.rbenv/bin/rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
eval "$(rbenv init -)"

echo 'To install run: rbenv install -l'
echo 'Check https://github.com/rbenv/rbenv for docs'
