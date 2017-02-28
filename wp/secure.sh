#!/bin/bash
: ${2?"Usage: $0 wpdir level[secure] sudo?"}

# TODO wpdir exists and contains wp-admin

wpdir=$1
level=$2
if [ $3 ]; then
    sudo="sudo"
else
    sudo=""
fi

# Test for wp directory
if [ ! -d "$wpdir" ]; then
    echo "Directory doesn't exist: $wpdir"
    exit 1
fi
if [ ! -d "$wpdir/wp-admin" ]; then
    echo "Directory doesn't seem to be Wordpress dir: $wpdir"
    exit 1
fi

if [ "$level" == "secure" ] 
then
    $sudo chmod -R a=rX,u+w $wpdir

    # All-in-One Migration
    $sudo chmod g+w "$wpdir/wp-content/plugins/all-in-one-wp-migration/storage"
    $sudo chgrp www-data "$wpdir/wp-content/plugins/all-in-one-wp-migration/storage"
else
    echo "Unknown level: $level"
    exit 1
fi

