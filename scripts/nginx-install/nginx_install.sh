#!/bin/bash

set -u
set -e

if (($# < 2)) && [ ! -e ./config.sh ]; then 
    echo -e "需要参数: 1:安装位置  2:版本号   [configureArg1...] or exits  ./config.sh"
    exit 1 
fi

source ./load_dependencies.sh

if [ -e ./config.sh ]; then
    source ./config.sh
else

    DEST=$1
    VERSION=$2
    SRC=/usr/local/src
    TAR=/usr/local/src/nginx-${VERSION}.tar.gz
    SRC_CODE=/usr/local/src/nginx-${VERSION}

fi

[ -e "$TAR" ] && { rm -rf "$TAR";  }

wget https://nginx.org/download/nginx-${VERSION}.tar.gz -P  "$SRC"


[ -e "$SRC_CODE" ] && { rm -rf "$SRC_CODE";  }

tar -xvf "$TAR"   -C  "$SRC" 

cd "$SRC_CODE"

if [ ! -e ./config.sh ]; then
    ARG="--with-http_ssl_module"
fi

if (($# >= 3)) && [ ! -e ./config.sh ]; then
    shift 3
    ARG=""
    for i; do 
        ARG+="$i  "
    done
fi


 ./configure  --prefix="$DEST"  $ARG  && make -j `egrep -c processor /proc/cpuinfo` && make install  

echo "make nginx and make install nginx successed !!!"
