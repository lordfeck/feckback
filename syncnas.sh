#!/bin/sh
# Feckback: Quick Rsync wrapper to sync NAS and USB Mirror.

nohup rsync --archive --exclude-from syncnas.ignore --bwlimit=5000 host:/volume1/{Archive,Share} /media/usbdisk/nas/ > rsync.log &
