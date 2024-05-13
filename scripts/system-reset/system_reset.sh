#!/bin/bash


LOCAL_REPO=1
LOCAL_REPO_IP=10.0.0.4
HOST_IP=10.0.0.3



# detect operation version
detect_os_version()
{
    ID=$(sed -rn 's/^ID=(.*)$/\1/p' /etc/os-release)
    MAIN_VERSION=$(sed -rn 's/^VERSION_ID="(.*)\..*$/\1/p' /etc/os-release)
}


#color output #1:color  #2:content
color_output() 
{
    if (($# == 0)); then
        return 1
    fi
    case $1 in
        red)
            echo -ne "\e[1;31m$2\e[0m"
            ;;
        green)
            echo -ne "\e[1;32m$2\e[0m"
            ;;
        yellow)
            echo -ne "\e[1;33m$2\e[0m"
            ;;
        *)
            echo -ne "\e[1;37m$2\e[0m"
            ;;
    esac
}


#print message $1:message
print_message() {

    if (($? == 0)); then
        local space=$((80-${#1}))
        echo -n  "$1"
        printf "%${space}s\n"  "$(color_output green "[success]")"
    else 
        local space=$((80-${#1}))
        echo -n  "$1"
        printf "%${space}s\n"  "$(color_output red "[failed]")"
        exit 1
    fi
}

disable_selinux()
{
    sed -ri  '/^SELINUX=/s/enforcing/disabled/' /etc/selinux/config
    print_message "disable selinux"
}

disable_firewall() 
{
    systemctl disable --now firewalld &>/dev/null
    print_message "disalbe default firewall policy"
}

aliyun_yum_repo_template()
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

local_yum_repo_template()
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
baseurl=http://$LOCAL_REPO_IP/linux/rockylinux/8/$repoName
gpgcheck=0
EOF

}

config_yum()
{
    #backup system yum repo
    local backupRepoDir=/etc/yum.repos.d/config-bak
    local repoDir=/etc/yum.repos.d
    local yumRepoDir="$repoDir/yum.repo"
    if [ ! -e "$backupRepoDir" ]; then
        mkdir -p  "$backupRepoDir"
    fi
    mv ${repoDir}/*.repo  "$backupRepoDir"

    print_message "backup system yum repo"

    #add yum repo
    if ((LOCAL_REPO == 1)); then
        local repoNameList="BaseOS  AppStream  extras epel"
        for repoName in  $repoNameList; do
            local_yum_repo_template "$repoName" "$repoName" "$repoName"   >> "$yumRepoDir"
            echo >> "$yumRepoDir"
        done
        yum clean all &>/dev/null
        print_message "yum clean all"
        yum makecache &>/dev/null
        print_message "yum makecache"
    else
        local repoNameList="BaseOS  AppStream  extras PowerTools"
        for repoName in  $repoNameList; do
            aliyun_yum_repo_template "$repoName" "$repoName" "$repoName"   >> "$yumRepoDir"
            echo >> "$yumRepoDir"
        done

        # 安装epel
        yum install -y epel-release
    fi

    print_message "add yum repo"
}

config_rocky_vim() 
{
    yum install vim -y &>/dev/null
    print_message "vim installed"
    if [ -e /etc/vimrc ]; then
        \mv --backup=numbered  /etc/vimrc    /etc/vimrc.bak
    fi
    cat ./vimrc.txt >> /etc/vimrc
    print_message "vim config"
}

config_rocky_mail() 
{
    yum -y install postfix mailx &>/dev/null
    print_message "install postfix mailx"
    systemctl enable --now postfix &>/dev/null
    print_message "postfix service enable"
}

install_common_app() 
{
    yum install -y  bash-completion psmisc lrzsz  tree man-pages redhat-lsb-core zip unzip bzip2 wget tcpdump ftp rsync vim lsof \
    &>/dev/null
    print_message "commonApp installed"

}


config_NTP() 
{
    yum install chrony -y &>/dev/null
    timedatectl set-ntp true &>/dev/null
    print_message "configNTP"
}

auto_mount_CD() 
{
    yum -y install autofs &>/dev/null
    systemctl enable --now autofs &>/dev/null
    print_message "autoMountCD"
}


config_rocky_network() 
{
    #modify network interface device name
    sed -i '/^GRUB_CMDLINE_LINUX=/s#"$# net.ifnames=0"#' /etc/default/grub
    grub2-mkconfig -o /etc/grub2.cfg &>/dev/null
    mkdir -p /etc/sysconfig/network-scripts/backup
    mv /etc/sysconfig/network-scripts/ifcfg*  /etc/sysconfig/network-scripts/backup
    cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes

IPADDR="$HOST_IP"
NETMASK=255.255.255.0
GATEWAY=10.0.0.2
DNS1=10.0.0.2
DNS2=8.8.4.4
EOF
    print_message "modify network interface"
}


reset_main() 
{
    detect_os_version
    if [[ $ID =~ rhel|rocky|centos ]]; then
        disable_selinux
        disable_firewall
        config_yum
        config_rocky_vim
        config_rocky_mail
        install_common_app
        config_NTP
        auto_mount_CD
        config_rocky_network
    elif [[ $ID =~ ubuntu ]]; then
        echo "ubuntu"
    fi

}

reset_main




