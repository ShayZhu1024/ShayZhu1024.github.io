#!/bin/bash

NEXUS_VERSION=3.69.0-02
NEXUS_URL="https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz"
INSTALL_DIR=/usr/local/nexus

HOST=`hostname -I|awk '{print $1}'`
GREEN="echo -e \E[32;1m"
END="\E[0m"

. /etc/os-release

color () {
    RES_COL=60
    MOVE_TO_COL="echo -en \\033[${RES_COL}G"
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"
    SETCOLOR_FAILURE="echo -en \\033[1;31m"
    SETCOLOR_WARNING="echo -en \\033[1;33m"
    SETCOLOR_NORMAL="echo -en \E[0m"
    echo -n "$1" && $MOVE_TO_COL
    echo -n "["
    if [ $2 = "success" -o $2 = "0" ] ;then
        ${SETCOLOR_SUCCESS}
        echo -n $"  OK  "    
    elif [ $2 = "failure" -o $2 = "1"  ] ;then 
        ${SETCOLOR_FAILURE}
        echo -n $"FAILED"
    else
        ${SETCOLOR_WARNING}
        echo -n $"WARNING"
    fi
    ${SETCOLOR_NORMAL}
    echo -n "]"
    echo 
}


install_jdk() {
    if [ $ID = "centos" -o  $ID = "rocky" ];then
        yum  -y install java-11-openjdk || { color "安装JDK失败!" 1; exit 1; } 
    else
        apt update
        apt -y install openjdk-11-jdk  || { color "安装JDK失败!" 1; exit 1; } 
    fi
    color "安装JDK完成!" 0
    java -version
}

install_nexus() {
    if [ -e ${NEXUS_URL##*/} ];then
        cp ${NEXUS_URL##*/} /usr/local/src
    else 
        wget -P /usr/local/src/ $NEXUS_URL || { color  "下载失败!" 1 ;exit ; }
    fi
    tar xf /usr/local/src/${NEXUS_URL##*/} -C /usr/local
    ln -s /usr/local/nexus-*/ ${INSTALL_DIR}
    ln -s ${INSTALL_DIR}/bin/nexus /usr/bin/
}

start_nexus (){
cat   > /lib/systemd/system/nexus.service <<EOF
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=${INSTALL_DIR}/bin/nexus start
ExecStop=${INSTALL_DIR}/bin/nexus stop
User=root
#User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOF
    systemctl daemon-reload 
    systemctl enable --now  nexus.service
    if [ $? -eq 0 ] ;then 
        color "nexus 安装成功" 0  
    echo "-------------------------------------------------------------------"
        echo -e "访问链接: \c"
    ${GREEN}"http://$HOST:8081/"${END}
    while [ ! -e ${INSTALL_DIR}/../sonatype-work/nexus3/admin.password ];do
        sleep 1
    done
    PASS=`cat ${INSTALL_DIR}/../sonatype-work/nexus3/admin.password`
    echo -e "用户和密码: \c"
    ${GREEN}"admin/$PASS"$END
    else 
        color "nexus 安装失败!" 1
        exit 1
    fi 
}


install_jdk
install_nexus
start_nexus
