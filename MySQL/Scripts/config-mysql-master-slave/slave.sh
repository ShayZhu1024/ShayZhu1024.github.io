#!/bin/bash

yum install mysql-server -y

SLAVE=`hostname -I | tr -d " "`
MASTER=10.0.0.8

cat >> /etc/my.cnf <<EOF
[mysqld]
general_log=1
log_bin=logbin
log_slave_updates
server_id=${SLAVE##*.}
read_only=ON
relay_log=relay-log
relay_log_index=relay-log.index
gtid_mode=ON
enforce_gtid_consistency=ON
replica_parallel_type=LOGICAL_CLOCK
replica_parallel_workers=2
EOF

systemctl enable --now mysqld
mysql -uroot -e "INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so'"

echo "rpl_semi_sync_master_enabled" >> /etc/my.cnf

systemctl restart  mysqld

mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='${MASTER}',MASTER_USER='replication',MASTER_PASSWORD='123456',MASTER_PORT=3306,MASTER_AUTO_POSITION=1;"

mysql -uroot -e "start slave"