#!/bin/bash
: ${1?"Usage: $0 dbname"}

db=$1
SQL="CREATE DATABASE $db; GRANT ALL PRIVILEGES ON $db.* TO '$db'@'localhost' IDENTIFIED BY '$db';"

echo $SQL
echo "Provide mysql root password:"
mysql -u root -p -e "$SQL"
