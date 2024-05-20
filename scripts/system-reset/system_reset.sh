#!/bin/bash


LOCAL_REPO=1
LOCAL_REPO_IP=10.0.0.4
HOST_IP="10.0.0.3"
NTP_SERVER_IP=10.0.0.4
ROCKY_HOSTNAME=rocky8-$(echo $HOST_IP | awk -F. '{print $4}')
UBUNTU_HOSTNAME=ubuntu20-$(echo $HOST_IP | awk -F. '{print $4}')



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


#############rockyLinux config begin##################

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

rocky_install_common_app() 
{
    yum install -y  bash-completion psmisc net-tools lrzsz  tree man-pages redhat-lsb-core zip unzip bzip2 wget tcpdump ftp rsync vim lsof \
    &>/dev/null
    print_message "commonApp installed"

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

#############rockyLinux config end##################


config_ntp() 
{
    if [[ $ID =~ rhel|centos|rocky ]]; then
        rpm -q chrony &>/dev/null
        if [ ! $? -eq 0 ]; then
            yum install -y chrony
        fi
        sed -ri 's/^(pool.*)$/#\1/' /etc/chrony.conf
cat >> /etc/chrony.conf <<EOF
server $NTP_SERVER_IP  iburst
EOF
        systemctl restart chronyd.service
    elif [[ $ID =~ ubuntu ]]; then
        dpkg -l chrony &>/dev/null
        if [ ! $? -eq 0 ]; then
            apt update
            apt install -y chrony
        fi
        sed -ri 's/^(pool.*)$/#\1/' /etc/chrony/chrony.conf
cat >> /etc/chrony/chrony.conf <<EOF
server $NTP_SERVER_IP  iburst
EOF
        systemctl restart chronyd.service
    else
          echo "系统版本不支持"
    fi
    print_message "NTP config" 
}


#############ubuntuLinux config begin###############
config_apt_source()
{
    if [ -e /etc/apt/sources.list ]; then
        mv /etc/apt/sources.list  /etc/apt/sources.list.bak
    fi

cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF

apt update

print_message "apt source update"

}


config_ubuntu_vim() 
{
    apt install vim -y
    print_message "vim installed"
    if [ -e /etc/vim/vimrc ]; then
        \mv --backup=numbered  /etc/vim/vimrc    /etc/vim/vimrc.bak
    fi
    cat ./vimrc.txt >> /etc/vim/vimrc
    print_message "vim config"
}

ubuntu_install_common_app() 
{
    apt purge ufw lxd lxd-client lxcfs liblxc-common  -y
    apt install bash-completion  net-tools  -y

    print_message "commonApp installed"

}

ubuntu_config_network()
{
    sed -ri '/^GRUB_CMDLINE_LINUX=/s#"$# net.ifnames=0"#' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg

    mkdir -p /etc/netplan/backup
    \mv /etc/netplan/*.yaml  /etc/netplan/backup
    \mv /etc/netplan/*.yml  /etc/netplan/backup
cat > /etc/netplan/eth0.yaml <<EOF
network: 
  version: 2 
  renderer: networkd
  ethernets: 
    eth0: 
      addresses: 
        - $HOST_IP/24
      gateway4: 10.0.0.2
      nameservers: 
        search: 
          - baidu.com
        addresses: 
          - 8.8.4.4
          - 10.0.0.2
EOF
netplan apply

}

ubuntu_config_timezone() 
{
    timedatectl set-timezone Asia/Shanghai
    print_message "set-timezone"
}

 permit_root_ssh() 
 {
    sed -ri 's/^#(PermitRootLogin) .*/\1 yes/' /etc/ssh/sshd_config
    systemctl restart sshd.service
    print_message permit ssh root login
 }

#############ubuntu config end######################

reset_main() 
{
    detect_os_version
    if [[ $ID =~ rhel|rocky|centos ]]; then
        disable_selinux
        disable_firewall
        config_yum
        config_rocky_vim
        config_rocky_mail
        rocky_install_common_app
        config_ntp
        auto_mount_CD
        config_rocky_network
        hostnamectl set-hostname "$ROCKY_HOSTNAME"
        print_message "set-hostname"
    elif [[ $ID =~ ubuntu ]]; then
        config_apt_source
        config_ubuntu_vim
        ubuntu_install_common_app
        ubuntu_config_network
        ubuntu_config_timezone
        config_ntp
        permit_root_ssh
        hostnamectl set-hostname "$UBUNTU_HOSTNAME"
        print_message "set-hostname"
        sed -ri "/^127.0.1.1/s/^.*$/127.0.0.1 ${UBUNTU_HOSTNAME}/" /etc/hosts
    fi
    echo "reboot....."
    reboot
}

reset_main




