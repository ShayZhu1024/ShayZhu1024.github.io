#!/bin/bash

source ./load_dependencies.sh
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
