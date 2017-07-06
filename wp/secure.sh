#!/bin/bash

#########  ARGUMENTS

: ${2?"Usage: $0 wpdir level[secure|install-plugin|core-upgrade] sudo?"}

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

#########  FUNCTIONS

function apache_writable { # dir
    if [ -d "$1" ]; then
    	echo "Making www-data writable: $1" 

    	$sudo chmod -R g+w $1
    	$sudo chgrp -R www-data $1
    else
        : 
	# echo "Warning: Directory doesnt' exist: $1"
    fi
}


#########  MAIN

if [ "$level" == "secure" ]; then
    echo "Making wordpress install [$level]: $wpdir"

    # default 755, 644
    $sudo chmod -R a=rX,u+w $wpdir 

    # allow media uploads, etc.
    apache_writable "$wpdir/wp-content/uploads"

    # All-in-One Migration
    apache_writable "$wpdir/wp-content/plugins/all-in-one-wp-migration/storage"

    # Wordfence data
    apache_writable "$wpdir/wp-content/wflogs"

    # Themes
    apache_writable "$wpdir/wp-content/themes/ventcamp/cache"

    # TODO backups shouldn't be accessible
    # apache_writable "$wpdir/wp-content/ai1wm-backups/"

elif [ "$level" == "install-plugin" ]; then
    echo "Making wordpress install [$level]: $wpdir"

    apache_writable "$wpdir/wp-content/upgrade"
    apache_writable "$wpdir/wp-content/languages"
    apache_writable "$wpdir/wp-content/plugins"

elif [ "$level" == "core-upgrade" ]; then
    echo "Making wordpress install [$level]: $wpdir"

    apache_writable "$wpdir/wp-content/upgrade"
    apache_writable "$wpdir/wp-content/languages"
    apache_writable "$wpdir/wp-admin"
    apache_writable "$wpdir/wp-includes"
    apache_writable "$wpdir/readme.html"
    apache_writable "$wpdir/license.txt"

    $sudo cp --backup=numbered $wpdir/wp-settings.php $wpdir/wp-settings.php.old
    apache_writable "$wpdir/wp-settings.php"

else
    echo "Unknown level: $level"
    exit 1
fi

