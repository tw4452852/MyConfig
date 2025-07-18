#!/usr/bin/env bash

set -e

cd /home/tw/code/void-mklive
sudo env ROOTDIR=/tmp https_proxy=http://proxy.nioint.com:8080 ./mktw.sh -s gzip -p "$(xbps-query -m | xargs xbps-uhelper getpkgname)"
sudo mount /dev/mapper/sdb1 /mnt/
sudo cp --verbose ./tw-void.iso /mnt/
sudo umount /mnt
