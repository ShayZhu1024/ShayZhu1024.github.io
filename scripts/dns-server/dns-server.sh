#!/bin/bash

set -e
set -u

DOMAIN="zhu.com"
LOCAL_IP=10.0.0.3

rpm -q bind &>/dev/null || yum install bind -y 
rpm -q bind-utils &>/dev/null  ||  yum install bind-utils -y

sed -ri '/^\t*listen-on/s/^/\/\//'   /etc/named.conf
sed -ri '/^\t*allow-query/s/^/\/\//'   /etc/named.conf
sed -ri  's/(^\t*dnssec-enable ).*$/\1 no;/'   /etc/named.conf
sed -ri 's/(^\t*dnssec-validation ).*$/\1 no;/'   /etc/named.conf
sed  -ri '/^\t*recursion/a \\tallow-transfer {none;};' /etc/named.conf
sed  -ri '/^\t*recursion/a \\tminimal-responses yes;' /etc/named.conf

cat >> /etc/named.rfc1912.zones <<EOF
zone "$DOMAIN" IN {
    type master;
    file "$DOMAIN.zone";
};
EOF

[ -e /var/named/$DOMAIN.zone ] && rm -rf /var/named/$DOMAIN.zone

cat >> /var/named/$DOMAIN.zone <<EOF
\$TTL 1D        
@   IN SOA  master shayzhu.126.com. (
                    0   ; serial
                    1D  ; refresh
                    1H  ; retry
                    1W  ; expire
                    3H )    ; minimum
          NS  master  
master    A   $LOCAL_IP
EOF

chmod --reference=/var/named/named.localhost  /var/named/$DOMAIN.zone
chown --reference=/var/named/named.localhost  /var/named/$DOMAIN.zone

named-checkconf
named-checkzone $DOMAIN  /var/named/$DOMAIN.zone

systemctl start named

echo "安装启动成功！！！"
