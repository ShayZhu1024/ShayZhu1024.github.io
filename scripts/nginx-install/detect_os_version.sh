#!/bin/bash


ID=`sed -rn 's/^ID=(.*)$/\1/p' /etc/os-release`
MAIN_VERSION=`sed -rn 's/^VERSION_ID="(.*)\..*$/\1/p' /etc/os-release`
