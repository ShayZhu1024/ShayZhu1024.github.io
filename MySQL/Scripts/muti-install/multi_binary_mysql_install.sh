#!/bin/bash

set -u
set -e

HOME=/data/mysql
TAR=/root/mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
MYSQL=mysql-8.3.0-linux-glibc2.28-x86_64
#默认开启3个示例 3306 3307 3308 在prepare_mysql_config 函数中可修改

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

    chown -R mysql:mysql "$HOME"
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
    mkdir -p /data/mysql/{3306,3307,3308}/{data,etc,socket,log,bin,pid}
    for dir in /data/mysql/*; do 
        cat > $dir/etc/my.cnf <<EOF
[mysqld]
port=${dir##*/}
datadir=$dir/data
socket=$dir/socket/mysql.sock
log-error=$dir/log/mysql.log
pid-file=$dir/pid/mysql.pid
EOF
    done
    chown -R mysql:mysql  /data/mysql
}







create_database()
{
    for dir in /data/mysql/*; do 
        mysqld --initialize-insecure  --user=mysql  --datadir=$dir/data
    done
}

prepare_script()
{
    for dir in /data/mysql/*; do 
        cat  ./start_script.sh  >  $dir/bin/mysqld
        sed -ri "s/(^port=).*$/\1${dir##*/}/"  $dir/bin/mysqld
    done

}

prepare_dependencies
echo "依赖准备完成"
prepare_user_group
echo "用户和组准备完成"
prepare_binary_mysql
echo "而进程程序解压完成"
prepare_mysql_config
echo "配置文件准备完成"
create_database
echo "数据库创建完成"
prepare_script
echo "启动脚本准备完成，成功！！！"


