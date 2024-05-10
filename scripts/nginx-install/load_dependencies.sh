#!/bin/bash

set -u
set -e


#inject various and formate: ID=ubuntu  MAIN_VERSION=20
source ./detect_os_version.sh

if [[ $ID =~ rhel|centos|rocky  ]]; then
    yum install -y gcc gcc-c++  pcre-devel openssl-devel pcre-devel  
fi

if [[ $ID =~ ubuntu ]]; then
    apt install -y gcc g++  libpcre3-dev  libssl-dev  zlib1g-dev  make 
fi

