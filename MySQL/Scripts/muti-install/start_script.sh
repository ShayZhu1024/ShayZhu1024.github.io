#!/bin/bash

port=3306
mysql_user="root"               #登录用户
mysql_pwd="1234567890"           #登录密码
cmd_path="/usr/local/mysql/bin"  #mysql二进制程序位置
mysql_basedir="/data/mysql"
mysql_sock="${mysql_basedir}/${port}/socket/mysql.sock"

function_start_mysql()
{
    if [ ! -e "$mysql_sock" ]; then 
        printf "Starting MySQL...\n"
        ${cmd_path}/mysqld  --defaults-file=${mysql_basedir}/${port}/etc/my.cnf --user=mysql  &
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