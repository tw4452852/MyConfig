#!/bin/bash

autoFiles=($HOME/.autoload.d/*.sh)

for file in "${autoFiles[@]}"; do
	source $file
done
