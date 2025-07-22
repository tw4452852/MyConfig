#!/usr/bin/env bash

set -e

cd /home/tw/t/notes/
git add root/index.html
git amend
git push -f
