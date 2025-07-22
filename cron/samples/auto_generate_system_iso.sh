#!/usr/bin/env bash

set -e

uuid1=7587b5ee-6669-44d5-88b4-61e433394890
dm1="$(blkid | grep "$uuid1" | grep /dev/mapper | cut -d':' -f1)"

cd /home/tw/code/void-mklive
sudo env ROOTDIR=/tmp ./mktw.sh -s gzip -p "$(xbps-query -m | xargs xbps-uhelper getpkgname)"
sudo mount $dm1 /mnt/
sudo cp --verbose ./tw-void.iso /mnt/new.iso
sudo umount /mnt
