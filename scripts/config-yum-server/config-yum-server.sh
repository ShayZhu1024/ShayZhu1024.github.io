#!/bin/bash


#前提配置好了远程yum源

BASE_DIR=/var/www/html/linux/rockylinux/8/
REPO_LIST="AppStream BaseOS epel extras"

#安装http服务器
yum install httpd -y
systemctl  enable --now  httpd

#创建好仓库基目录
mkdir -p $BASE_DIR

for repo in $REPO_LIST; do 
    { yum reposync --repoid="$repo"  --download-metadata  -p $BASE_DIR &>/dev/null; } &
done

wait

echo "yum 仓库配置完毕!!!"
