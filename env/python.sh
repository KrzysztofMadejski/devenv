#!/bin/bash
local=0
while getopts "gh" opt; do
  case "$opt" in
  h|\?)
      show_help
      exit 0
      ;;
  l)  local=1
      ;;
  esac
done

function on_startup {
    # Save to startup file and enable
    echo $1 >> ~/.bashrc
    `$1`
}

pip_user_flag=

if [ $local ]; then
    pip_user_flag=--user
    on_startup 'export PATH="$PATH:$HOME/.local/bin"'
else
fi

if ! [ -x "$(command -v pip)" ]; then
    wget https://bootstrap.pypa.io/get-pip.py

    python get-pip.py $pip_user_flag

    rm get-pip.py
fi

pip install $pip_user_flag virtualenvwrapper

on_startup 'export WORKON_HOME=$HOME/.virtualenvs'
if [ $local ]; then
    on_startup 'source virtualenvwrapper.sh'
else
    on_startup 'source /usr/local/bin/virtualenvwrapper.sh'
fi

