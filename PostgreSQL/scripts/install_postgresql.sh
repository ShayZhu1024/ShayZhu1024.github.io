#!/bin/bash
################################
# Author: ShayZhu
# Contact: shayzhu@126.com
# Version: 1.0.0
# Date: 2024-06-11
# Description:
################################

set -u
set -e


PGSQL=postgresql-16.3
DATA=/data/postgres/16/data
PGSQL_HOME=/data/postgres
APP=/apps/pgsql/

yum install make readline-devel zlib-devel gcc libicu-devel -y

[ -e  "./${PGSQL}" ] && rm -rf ./"${PGSQL}"

tar  xf ${PGSQL}.tar.bz2  

cd ./${PGSQL}

./configure --prefix=$APP  --with-pgport=5432

make -j 2 world

getent passwd postgres &&  userdel  -r postgres
getent group postgres && groupdel postgres
groupadd -r postgres

[ -e $PGSQL_HOME ] && rm -rf $PGSQL_HOME

useradd -r -s /bin/bash -m -g postgres -d $PGSQL_HOME  postgres
echo "postgres:123456" | chpasswd

[ -e $APP ] && rm  -rf  $APP

make install-world

[ -e "${DATA}" ] && rm -rf "$DATA"
mkdir -p "$DATA"
chown postgres:postgres  -R  "$DATA"

cat > /etc/profile.d/pgsql.sh <<EOF
export PGHOME=$APP
export PATH+=:\$PGHOME/bin/
export PGDATA=$DATA
export PGUSER=postgres
export MANPATH+=:$APP/share/man
EOF

source /etc/profile.d/pgsql.sh

su - postgres  -c "$APP/bin/initdb -D $DATA"

cat  > /lib/systemd/system/postgresqld.service  <<EOF
[Unit]
Description=PostgreSQL 16 database server
Documentation=https://www.postgresql.org/docs/16/static/
After=syslog.target
After=network-online.target

[Service]
User=postgres
Group=postgres

ExecStart=/apps/pgsql/bin/postgres  -D /data/postgres/16/data 
ExecReload=/bin/kill -HUP  \$MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload 

#systemctl start postgresqld.service

#$APP/bin/psql -U postgres -h127.0.0.1 -d postgres -c "alter user postgres with password '123456';"

sed -ri  "/^# IPv4 local connectio/a \host    all             all             10.0.0.0/24             md5" ${DATA}/pg_hba.conf
sed  -ri "s/^#(listen_addresses = ).*/\1'*'/"  ${DATA}/postgresql.conf

systemctl start  postgresqld.service

