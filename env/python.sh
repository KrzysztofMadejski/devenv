#!/bin/bash
local=1
while getopts "gh" opt; do
  case "$opt" in
  h|\?)
      show_help
      exit 0
      ;;
  g)  local=0 #TODO handle it, as pip installs now by default into local
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

# wrappers for different pythons
on_startup "alias mkvirtualenv3='mkvirtualenv --python=`which python3`'"
on_startup "alias mkvirtualenv2='mkvirtualenv --python=`which python2`'"


