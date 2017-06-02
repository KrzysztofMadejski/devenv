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

if [ $local ]; then
	local install curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
else
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | sudo NVM_DIR=/usr/local/nvm bash
	export NVM_DIR="/usr/local/nvm"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
