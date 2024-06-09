#!/bin/bash


set -u
set -e


#1.ssh 免密登录搞定
#2. 1主2从配置好了
#此脚本在centos7上跑
#每个机器上需要配置好yum 尤其epel源

MASTER=10.0.0.8
SLAVE1=10.0.0.9
SLAVE2=10.0.0.7

yum install -y ./mha4mysql-manager-0.58-0.el7.centos.noarch.rpm   ./mha4mysql-node-0.58-0.el7.centos.noarch.rpm 

scp -o StrictHostKeyChecking=no  ./mha4mysql-node-0.58-0.el7.centos.noarch.rpm  $SLAVE1
scp -o StrictHostKeyChecking=no  ./mha4mysql-node-0.58-0.el7.centos.noarch.rpm  $SLAVE2

ssh -o StrictHostKeyChecking=no $SLAVE1  "yum install -y ./mha4mysql-node-0.58-0.el7.centos.noarch.rpm"
ssh -o StrictHostKeyChecking=no $SLAVE2  "yum install -y ./mha4mysql-node-0.58-0.el7.centos.noarch.rpm"

cat > /etc/mastermha/app1.cnf <<EOF
[server default]

check_repl_delay=0
manager_log=/data/mastermha/app1/manager.log
manager_workdir=/data/mastermha/app1
master_binlog_dir=/var/lib/mysql/
master_ip_failover_script=/usr/local/bin/master_ip_failover.sh
password=123456
ping_interval=1
remote_workdir=/data/mastermha/app1/
repl_password=123456
repl_user=replication
report_script=/usr/local/bin/sendmail.sh
ssh_user=root
user=root


[server1]
candidate_master=1
hostname=${MASTER}

[server2]
candidate_master=1
hostname=${SLAVE1}

[server3]
hostname=${SLAVE2}
EOF

cat > /usr/local/bin/sendmail.sh  <<EOF
echo "mha is failover" | mail -s "MHA Warning" "shayzhu@126.com"
EOF

yum install mailx postfix -y

cat >> /etc/mail.rc <<EOF
set from=xxxxx@qq.com              
set smtp=smtp.qq.com                   
set smtp-auth-user=xxxxx@qq.com    
set smtp-auth-password=xxxxx
set smtp-auth=login
EOF

#VIP 在./master_ip_failover 这个文件中配置
cat > /usr/local/bin/master_ip_failover  ./master_ip_failover

chmod +x /usr/local/bin/sendmail.sh
chmod +x /usr/local/bin/master_ip_failover 


#配置master VIP,和./master_ip_failover 文中相同
ssh -o StrictHostKeyChecking=no  $MASTER  "ifconfig eth0:1 10.0.0.250/24"


#检查
masterha_check_ssh --conf=/etc/mastermha/app1.cnf && echo "check success!!" || echo "check failed!"
masterha_check_repl --conf=/etc/mastermha/app1.cnf && echo "check success!!" || echo "check failed!"
masterha_check_status --conf=/etc/mastermha/app1.cnf && echo "check success!!" || echo "check failed!"

#启动
masterha_manager --conf=/etc/mastermha/app1.cnf --remove_dead_master_conf --ignore_last_failover