#!/bin/bash

set -u
set -e

#################注意#####################
#需要在主服务器上创建mycat的连接管理账号
#################注意#####################
#mycat 端口和数据库设置可以在  ./schema.xml 和 ./server.xml 修改


#MASTER=10.0.0.8
#mysql -uroot  -h $MASTER -e "create user root@'10.0.0.%' identified by '123456' "
#mysql -uroot  -h $MASTER -e "grant all on *.* to root@'10.0.0.%'"

MYCAT=Mycat-server-1.6.7.6-release-20210303094759-linux
DIR=/apps/
yum install -y java

[ -e $DIR ] && rm -rf $DIR 
mkdir -p $DIR

tar xf ${MYCAT}.tar.gz  -C $DIR
echo "PATH+=:${DIR}/mycat/bin" > /etc/profile.d/mycat.sh
source /etc/profile.d/mycat.sh

cat > ${DIR}/mycat/conf/server.xml  ./server.xml
cat > ${DIR}/mycat/conf/schema.xml  ./schema.xml
mycat start