#!/bin/bash


#支持在线下载

MAVEN_VERSION=3.9.8
MAVEN_FILE=apache-maven-${MAVEN_VERSION}-bin.tar.gz
JAVA_VERSION=8
MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_FILE}
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

check () {
    if [ ! -e ${MAVEN_FILE} ];then
        color  "文件${MAVEN_FILE}不存在!"  1
        wget $MAVEN_URL || { color  "文件${MAVEN_FILE}下载失败!"  1; exit ; }
    fi
}

install_maven () {
    apt update
    apt -y install openjdk-${JAVA_VERSION}-jdk 
    tar xf ${MAVEN_FILE}  -C /usr/local/
    ln -s /usr/local/apache-maven-*/ /usr/local/maven
    echo 'PATH=/usr/local/maven/bin:$PATH' > /etc/profile.d/maven.sh
    echo 'export MAVEN_HOME=/usr/local/maven' >> /etc/profile.d/maven.sh
    . /etc/profile.d/maven.sh
    mvn -v && color  "MAVEN安装成功!" 0 || color  "MAVEN安装失败!"  1
}

mirror () {
    sed -i  '/\/mirrors>/i <mirror> \n <id>nexus-aliyun</id> \n  <mirrorOf>*</mirrorOf> \n <name>Nexus aliyun</name> \n <url>http://maven.aliyun.com/nexus/content/groups/public</url> \n </mirror> ' /usr/local/maven/conf/settings.xml
}


check 

install_maven

mirror





