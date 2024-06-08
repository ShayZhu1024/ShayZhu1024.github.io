#!/bin/bash

#要求两台机器，可以互相ssh

MASTER=10.0.0.8  #执行这个脚本的机器
SLAVE1=10.0.0.9
SLAVE2=10.0.0.7


yum install mysql-server -y


cat >> /etc/my.cnf <<EOF
[mysqld]
general_log=1
log_bin=logbin
server_id=${MASTER##*.}
gtid_mode=ON
enforce_gtid_consistency=ON
EOF


systemctl enable --now mysqld
mysql -uroot -e "INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so'"

cat >> /etc/my.cnf <<EOF
rpl_semi_sync_master_enabled
rpl_semi_sync_master_timeout=10000
EOF

systemctl restart  mysqld

mysql -uroot -e "create user replication@'10.0.0.%' identified by '123456'"
mysql -uroot -e "grant all on *.* to replication@'10.0.0.%'"


ssh -o StrictHostKeyChecking=no $SLAVE1  /bin/bash   < ./slave.sh
ssh -o StrictHostKeyChecking=no $SLAVE2  /bin/bash   < ./slave.sh
