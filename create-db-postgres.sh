#!/bin/bash
: ${1?"Usage: $0 dbname"}

db=$1
echo "sudo -u postgres psql -c "CREATE USER $db WITH PASSWORD '$db';"
echo "sudo -u postgres createdb -O $db $db -E utf-8"

sudo -u postgres psql -c "CREATE USER $db WITH PASSWORD '$db';"
sudo -u postgres createdb -O $db $db -E utf-8
