#!/bin/bash

# Feckback Setup Script
# Author: Lordfeck

if [ -n "$1" ]; then
    jobname="$1"
fi

readonly confDir="$HOME/.config"

function checkFatal {
    if [ "$?" -ne "0" ]; then 
        echo "$@"
        exit 1
    fi
}

function copyConf {
    local dest="$2"
    mkdir -pv "$dest"

    if [ -s "$dest/$1.conf" ]; then
        echo "$1.conf already exists, skipping copy stage."
    else
        cp -v "./feckback.conf" "$dest/$1.conf"
        checkFatal "installing $1.conf"
    fi

    if [ -s "$dest/$1.exclude" ]; then
        echo "$1.exclude already exists, skipping copy stage."
    else
        cp -v "./feckback.exclude" "$dest/$1.exclude"
        checkFatal "installing $1.conf"
    fi
}

# If a param is supplied, use it as jobname. Else only install default.

if [ -n "$jobname" ]; then
    echo "Installing new job $jobname to $confDir/feckback.d/$jobname.conf..."
    mkdir -pv "$confDir/feckback.d"
    checkFatal "Creating feckback.d"

    echo "First installing default feckback.conf, if not already present."
    copyConf "feckback" "$confDir"
    echo "Now installing $jobname"
    copyConf "$jobname" "$confDir/feckback.d"
else
    copyConf "feckback" "$confDir"
fi

echo "Setup complete."
