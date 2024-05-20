#!/bin/bash

BASE_DIR=/var/www/html/linux/

yum install sshpass -y

sshpass -p 123456 scp -o StrictHostKeyChecking=no  -r  10.0.0.4:$BASE_DIR    $BASE_DIR  &>/dev/null

echo "拷贝完毕！！！！"
