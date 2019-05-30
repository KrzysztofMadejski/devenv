#!/bin/bash

#########  ARGUMENTS

# Parsing, credits to https://stackoverflow.com/a/29754866/803174

set -o errexit -o pipefail -o noclobber -o nounset

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=su:
LONGOPTS=sudo,user:

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1 then getopt has complained about wrong arguments to stdout
    exit 2
fi
eval set -- "$PARSED"

sudo=""
user="www-data"

while true; do
    case "$1" in
        -s|--sudo)
            sudo="sudo"
            shift
            ;;
        -u|--user)
            user="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# handle non-option arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 wpdir level[secure|install-plugin|core-upgrade] [--sudo] [--user wp]"
    exit 1
fi

wpdir=$1
level=$2

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

function apache_writable {
    if [ -e "$1" ]; then
    	echo "Setting as writable: $1" 

    	$sudo chmod -R g+w $1
    	$sudo chgrp -R $user $1
    else
        : 
	# echo "Warning: Directory doesnt' exist: $1"
    fi
}


#########  MAIN

if [ "$level" == "secure" ]; then
    echo "Making wordpress install [$level]: $wpdir"

    # default 755, 644
    echo "Securing all files: a=rX,u+w"
    $sudo chmod -R a=rX,u+w $wpdir 

    # allow media uploads, etc.
    apache_writable "$wpdir/wp-content/uploads"

    # All-in-One Migration
    apache_writable "$wpdir/wp-content/plugins/all-in-one-wp-migration/storage"

    # Wordfence data
    apache_writable "$wpdir/wp-content/wflogs"

    # Themes
    apache_writable "$wpdir/wp-content/themes/ventcamp/cache"

    # ACF definitions in all themes
    find $wpdir/wp-content/themes -type d -name acf-json |  while read dir; do 
    	apache_writable "$dir" 
    done

    # TODO backups shouldn't be accessible
    # apache_writable "$wpdir/wp-content/ai1wm-backups/"

elif [ "$level" == "install-plugin" ]; then
    echo "Making wordpress install [$level]: $wpdir"

    apache_writable "$wpdir/wp-content/upgrade"
    apache_writable "$wpdir/wp-content/languages"
    apache_writable "$wpdir/wp-content/plugins"

elif [ "$level" == "core-upgrade" ]; then
    echo "Securing first.."
    ${0} $wpdir secure $sudo
    echo ""

    echo "Making wordpress install [$level]: $wpdir"

    apache_writable "$wpdir/wp-content/upgrade"
    apache_writable "$wpdir/wp-content/languages"
    apache_writable "$wpdir/wp-admin"
    apache_writable "$wpdir/wp-includes"
    apache_writable "$wpdir/readme.html"
    apache_writable "$wpdir/license.txt"
    apache_writable "$wpdir/wp-signup.php"
    apache_writable "$wpdir/wp-login.php"

    $sudo cp --backup=numbered $wpdir/wp-settings.php $wpdir/wp-settings.php.old
    apache_writable "$wpdir/wp-settings.php"

else
    echo "Unknown level: $level"
    exit 1
fi

