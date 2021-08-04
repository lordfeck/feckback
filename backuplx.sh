#!/bin/bash

# Feckback: Linux Backup Script
# Author: Lordfeck. Authored: 5/07/2020

function checkFatal {
    if [ "$?" -ne "0" ]; then
        echo "Failure when $@"
        exit 1
    fi
}

# Params indicate a jobname, otherwise homedir
if [ ! -n "$1" ]; then
    jobname="homedir"
    fbConf="${HOME}/.config/feckback.conf"
    excludeText="${HOME}/.config/feckback.exclude"
else
    jobname="$1"
    fbConf="${HOME}/.config/feckback.d/$jobname.conf"
    excludeText="${HOME}/.config/feckback.d/$jobname.exclude"
fi

source "$fbConf"
checkFatal  "reading config file. Exiting."


if [ ! -e "$excludeText" ]; then
    noExclude="1"
else
    excludeDirs="$(cat $excludeText | tr '\n' ',')"
fi

: ${toBackup:?"Fatal: Backup source unset."}
: ${destPath:?"Fatal: Backup destination path unset."}
: ${destHost:?"Fatal: Backup destination host unset."}
: ${localDest:?"Fatal: Local destination path unset."}

backupFile="$( hostname )-${USER}-${jobname}.tar.gz"

# Begin main execution... or interpretation?

echo -e "Feckback begins.\nJobname: $jobname\nSrc: $toBackup."
echo "Excluding: $excludeDirs"
echo "Destination Host: $destHost"
echo "Destination Path: $destPath"
echo "Backup File: $backupFile"
echo "Local Destination: $localDest"

echo "Stage 1: Connect to destination and create destination directory, if necessary."
ssh "$destHost" mkdir -pv "$destPath"
checkFatal "connecting to dest. host or creating dest. directory"

sleep 1
echo "Stage 2: Creating the backup in /$localDest/$backupFile"
mkdir -pv "/$localDest/"
checkFatal "creating destination directory"

if [ "$noExclude" = 1 ]; then
    tar -czf "/$localDest/$backupFile" "$toBackup"
    checkFatal "creating local backup archive"
else
    tar -czf "/$localDest/$backupFile" -X "$excludeText" "$toBackup"
    checkFatal "creating local backup archive"
fi

sleep 1
echo "Stage 3: Copy backup to destination host."
scp "/$localDest/$backupFile" "$destHost:$destPath"
checkFatal "Copying backup archive to destination."
