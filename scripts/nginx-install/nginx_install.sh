#!/bin/bash


DEST=/apps/nginx/     #nginx的安装位置
VERSION=1.20.2      #nginx的版本
SRC=/usr/local/src/  #nginx的压缩包存放位置
ARG=--with-http_ssl_module  #./configure 的配置参数


ID=`sed -rn 's/^ID=(.*)$/\1/p' /etc/os-release`
MAIN_VERSION=`sed -rn 's/^VERSION_ID="(.*)\..*$/\1/p' /etc/os-release`


if [[ $ID =~ rhel|centos|rocky  ]]; then
    yum install -y gcc gcc-c++  pcre-devel openssl-devel pcre-devel  wget make
fi

if [[ $ID =~ ubuntu ]]; then
    apt install -y gcc g++  libpcre3-dev  libssl-dev  zlib1g-dev  make wget
fi


source ./config.sh

TAR=${SRC}/nginx-${VERSION}.tar.gz 
SRC_CODE=${SRC}/nginx-${VERSION}

[ -e "$TAR" ] && { rm -rf "$TAR";  }

wget https://nginx.org/download/nginx-${VERSION}.tar.gz -P  "$SRC"

[ -e "$SRC_CODE" ] && { rm -rf "$SRC_CODE";  }

tar -xvf "$TAR"   -C  "$SRC" 

cd "$SRC_CODE"

./configure  --prefix="$DEST"  $ARG  && make -j `egrep -c processor /proc/cpuinfo` && make install  

(( ${?} == 0)) && echo "make nginx and make install nginx successed !!!"
