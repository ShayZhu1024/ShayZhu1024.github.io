#!/bin/bash

set -e
set -u

detect_os_version()
{
    ID=`sed -rn 's/^ID=(.*)$/\1/p' /etc/os-release`
    MAIN_VERSION=`sed -rn 's/^VERSION_ID="(.*)\..*$/\1/p' /etc/os-release`
}



if [[ $ID =~ rhel|centos|rocky ]]; then
     yum install -y chrony
elif [[ $ID =~ ubuntu ]]; then
     apt update; apt install -y chrony
else
     echo "系统版本不支持"
fi


detect_os_version