#!/bin/bash

ifstat -p $1 | grep $1 | awk '{print "RX:" $6 " TX:" $8}'
