#!/bin/bash

source  ./common.sh


#config aliyun yum repo remote
createyumRepoByTemplate()
{
    if (($# != 3)); then
        return 1
    fi

    local id="$1"
    local name="$2"
    local repoName="$3"
cat <<EOF
[$id]
name=$name
baseurl=https://mirrors.aliyun.com/rockylinux/\$releasever/$repoName/\$basearch/os/
gpgcheck=0
EOF

}

#config aliyun yum repo local
createLocalyumRepoByTemplate()
{
    if (($# != 3)); then
        return 1
    fi

    local id="$1"
    local name="$2"
    local repoName="$3"
cat <<EOF
[$id]
name=$name
baseurl=http://10.0.0.4/linux/rockylinux/8/$repoName
gpgcheck=0
EOF

}


configYum()
{
    #backup system yum repo
    local backupRepoDir=/etc/yum.repos.d/config-bak
    local repoDir=/etc/yum.repos.d
    local aliyumRepoDir="$repoDir/aliyun.repo"
    if [ ! -e "$backupRepoDir" ]; then
        mkdir -p  "$backupRepoDir"
    fi
    mv ${repoDir}/*.repo  "$backupRepoDir"

    printMessage "backup system yum repo"

    #add aliyun yum repo
    local repoNameList="BaseOS  AppStream  extras epel"
    for repoName in  $repoNameList; do
        createLocalyumRepoByTemplate "$repoName" "$repoName" "$repoName"   >> "$aliyumRepoDir"
        echo >> "$aliyumRepoDir"
    done

    # 安装epel, local 不需要，remote 打开
    #yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm &>/dev/null

    #printMessage "yum install epel"


    printMessage "add aliyun yum repo"

    yum clean all &>/dev/null

    printMessage "yum clean all"

    yum makecache &>/dev/null

    printMessage "yum makecache"
}

disableSelinuxFirewall() 
{
    sed -ri  '/^SELINUX=/s/enforcing/disabled/' /etc/selinux/config

    printMessage "disable selinux"

    systemctl disable --now firewalld &>/dev/null

    printMessage "disalbe default firewall policy"
}

configVim() 
{
    yum install vim -y &>/dev/null

    printMessage "vim installed"

    if [ -e /etc/vimrc ]; then
        mv /etc/vimrc    /etc/vimrc.bak
    fi
    cat vimrc.txt >> /etc/vimrc

    printMessage "vim config"
}

configMail() 
{
    yum -y install postfix mailx &>/dev/null
    printMessage "install postfix mailx"
    systemctl enable --now postfix &>/dev/null
    printMessage "postfix service enable"
}

installCommonApp() 
{
    yum install -y  bash-completion psmisc lrzsz  tree man-pages redhat-lsb-core zip unzip bzip2 wget tcpdump ftp rsync vim lsof \
    &>/dev/null
    printMessage "commonApp installed"

}

# $1 ip addr
configNetwork() 
{
    #modify network interface device name
    sed -i '/^GRUB_CMDLINE_LINUX=/s#"$# net.ifnames=0"#' /etc/default/grub
    grub2-mkconfig -o /etc/grub2.cfg &>/dev/null
    mkdir -p /etc/sysconfig/network-scripts/backup
    mv /etc/sysconfig/network-scripts/ifcfg*  /etc/sysconfig/network-scripts/backup
    cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=eth0
UUID=318ae4ad-e63d-4b94-9ef0-56355c70acf2
DEVICE=eth0
ONBOOT=yes

IPADDR="$1"
NETMASK=255.255.255.0
GATEWAY=10.0.0.2
DNS1=10.0.0.2
DNS2=8.8.4.4
EOF
    systemctl restart NetworkManager
    printMessage "modify network interface"
}

configNTP() 
{
    yum install chrony -y &>/dev/null
    timedatectl set-ntp true &>/dev/null
    printMessage "configNTP"
}

autoMountCD() 
{
    yum -y install autofs &>/dev/null
    systemctl enable --now autofs &>/dev/null
    printMessage "autoMountCD"
}

resetMain() {
    disableSelinuxFirewall
    configYum
    configVim
    configMail
    installCommonApp
    configNTP
    autoMountCD
    configNetwork "$1"
    printMessage "all reset"
    echo "The system will reboot in 10s"
    hostnamectl set-hostname rocky8-"$2"
    sleep 10
    reboot
}

resetMain "$1" "$2"
