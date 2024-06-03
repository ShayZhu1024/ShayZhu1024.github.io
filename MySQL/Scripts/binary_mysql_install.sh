#!/bin/bash

set -u
set -e


HOME=/data/mysql
TAR=/root/mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
MYSQL=mysql-8.3.0-linux-glibc2.28-x86_64


prepare_dependencies()
{
     yum install libaio  numactl-libs   ncurses-compat-libs -y 
}

prepare_user_group() 
{
    getent passwd mysql &>/dev/null &&  userdel -r mysql
    getent group mysql &>/dev/null && groupdel mysql
    
    [ -e "$HOME" ] && rm -rf "$HOME"
    mkdir -p "$HOME"

    groupadd -r -g 306 mysql
    useradd -r -g 306  -u 306 -d $HOME -M  -s /bin/false mysql

    chown mysql:mysql "$HOME"
}

prepare_binary_mysql()
{
    tar xf "${TAR}"  -C  /usr/local
    ln -s  ./${MYSQL}  /usr/local/mysql
    chown -R root:root /usr/local/mysql
    echo "PATH+=:/usr/local/mysql/bin" > /etc/profile.d/mysql.sh
    source /etc/profile.d/mysql.sh
}

prepare_mysql_config()
{
   [ -e /etc/my.cnf ] && rm -rf  /etc/my.cnf
   cat > /etc/my.cnf <<EOF
[mysqld]
datadir=/data/mysql
skip_name_resolve=1
socket=/data/mysql/mysql.sock
log-error=/data/mysql/mysql.log
pid-file=/data/mysql/mysql.pid

[client]
socket=/data/mysql/mysql.sock
prompt="\\R:\\m:\\s(\\u@\\h) [\\d]>\\_"

EOF
}


init_database()
{
    #生成随机密码 grep password /data/mysql/mysql.log
    # mysqld --initialize --user=mysql --datadir=/data/mysql 

    #root 空密码
    mysqld --initialize-insecure  --user=mysql  --datadir=/data/mysql

}

prepare_service_script()
{
    cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
    chkconfig --add  mysqld
    service mysqld start
}


prepare_dependencies
prepare_user_group
prepare_binary_mysql
prepare_mysql_config
init_database
prepare_service_script