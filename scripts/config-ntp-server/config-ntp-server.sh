#!/bin/bash

detect_os_version()
{
    ID=`sed -rn 's/^ID=(.*)$/\1/p' /etc/os-release`
    MAIN_VERSION=`sed -rn 's/^VERSION_ID="(.*)\..*$/\1/p' /etc/os-release`
}

rocky_ntp()
{
     rpm -q chrony &>/dev/null
     if [ ! $? -eq 0 ]; then
           yum install -y chrony
     fi
     sed -ri 's/^(pool.*)$/#\1/' /etc/chrony.conf
cat >> /etc/chrony.conf <<EOF
server ntp.aliyun.com iburst
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
allow 0.0.0.0/0
local stratum 10
EOF
systemctl restart chronyd.service
echo "ntp server config success!!!"
}

ubuntu_ntp()
{
     dpkg -l chrony &>/dev/null
     if [ ! $? -eq 0 ]; then
          apt update
          apt install -y chrony
     fi
     sed -ri 's/^(pool.*)$/#\1/' /etc/chrony/chrony.conf
cat >> /etc/chrony/chrony.conf <<EOF
server ntp.aliyun.com iburst
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
allow 0.0.0.0/0
local stratum 10
EOF
systemctl restart chronyd.service
echo "ntp server config success!!!"
}


config_ntp_server()
{
     if [[ $ID =~ rhel|centos|rocky ]]; then
          rocky_ntp
     elif [[ $ID =~ ubuntu ]]; then
          ubuntu_ntp
     else
          echo "系统版本不支持"
     fi
}

detect_os_version
config_ntp_server