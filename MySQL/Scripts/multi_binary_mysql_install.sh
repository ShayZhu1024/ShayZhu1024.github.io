#!/bin/bash

set -u
set -e

HOME=/data/mysql
TAR=/root/mysql-8.3.0-linux-glibc2.28-x86_64.tar.xz
MYSQL=mysql-8.3.0-linux-glibc2.28-x86_64
INSTANCES='{3306,3307,3308}'

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
    mkdir -p /data/mysql/$INSTANCES{data,etc,socket,log,bin,pid}
    chown -R mysql:mysql  /data/mysql
    for dir in /data/mysql/*; do 
        cat > dir/etc/my.cnf <<EOF
[mysqld]
port=${dir##*/}
datadir=$dir/data
socket=$dir/socket/mysql.sock
log-error=$dir/log/mysql.log
pid-file=$dir/pid/mysql.pid
EOF
    done
}







create_database()
{
    for dir in /data/mysql/*; do 
        mysql_install_db --user=mysql --datadir=$dir/data 
    done
}

prepare_script()
{
    for dir in /data/mysql/*; do 
        cat  >  $dir/bin/mysqld <<EOF
#!/bin/bash

port=${dir##*/}
mysql_user="root"               #登录用户
mysql_pwd="1234567890"           #登录密码
cmd_path="/usr/local/mysql/bin"  #mysql二进制程序位置
mysql_basedir="/data/mysql"
mysql_sock="${mysql_basedir}/${port}/socket/mysql.sock"

function_start_mysql()
{
    if [ ! -e "$mysql_sock" ]; then 
        printf "Starting MySQL...\n"
        ${cmd_path}/mysqld_safe  --defaults-file=${mysql_basedir}/${port}/etc/my.cnf --user=mysql &> /dev/null &
    else
        printf "MySQL is running...\n"
        exit
    fi
}

function_stop_mysql()
{
    if [ ! -e "$mysql_sock" ]; then 
        printf "MySQL is stopped...\n"
        exit
    else
        printf "Stoping MySQL...\n"
        ${cmd_path}/mysqladmin -u ${mysql_user} -p${mysql_pwd} -S ${mysql_sock}  shutdown
    fi
}

function_restart_mysql()
{
    printf "Restarting MySQL...\n"
    function_stop_mysql
    sleep 2
    function_start_mysql
}

case $1 in
    start)
        function_start_mysql
        ;;
    stop)
         function_stop_mysql
        ;;
    restart)
          function_restart_mysql
        ;;
    *)
           printf "Usage: ${mysql_basedir}/${port}/bin/mysqld {start|stop|restart}\n"
esac

EOF
    done

}

prepare_dependencies
prepare_user_group
prepare_binary_mysql
prepare_mysql_config
create_database
prepare_scrip


