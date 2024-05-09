#!/bin/bash

set -u
set -e

DEST=/app/nginx
VERSION=1.20.2
SRC=/usr/local/src
TAR=/usr/local/src/nginx-1.20.2.tar.gz
SRC_CODE=/usr/local/src/nginx-1.20.2
ARG=--with-http_ssl_module
