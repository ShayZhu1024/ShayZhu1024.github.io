#!/bin/bash

DOMAIN="zhu.com"

rpm -q bind &>/dev/null || yum install bind -y 
rpm -q bind-utils &>/dev/null  ||  yum install bind-utils -y

sed -ri '/^\t*listen-on/s/^/\/\//'   /etc/named.conf
sed -ri '/^\t*allow-query/s/^/\/\//'   /etc/named.conf
sed -ri  's/(^\t*dnssec-enable ).*$/\1 no;/'   /etc/named.conf
sed -ri 's/(^\t*dnssec-validation ).*$/\1 no;/'   /etc/named.conf
sed  -ri '/^\t*recursion/a \\tallow-transfer {none;};' /etc/named.conf

cat >> /etc/named.rfc1912.zones <<EOF

EOF

cat >> /var/named/$DOMAIN.zone <<EOF

EOF

chmod --reference=/var/named/named.localhost  /var/named/$DOMAIN.zone
chown --reference=/var/named/named.localhost  /var/named/$DOMAIN.zone

named-checkconf
named-checkzone $DOMAIN  /var/named/$DOMAIN.zone

echo "安装启动成功！！！"
