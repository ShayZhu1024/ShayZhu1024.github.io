#!/bin/bash


HOST_IP="10.0.0.200"
NTP_SERVER_IP=10.0.0.4
UBUNTU_HOSTNAME=ubuntu-$(echo $HOST_IP | awk -F. '{print $4}')
QQ_MAIL_FROM=xxxxxxx@qq.com
AUTH_PASSWORD=xxxxxxxx
TEST_MAIL=xxxxxxxx@126.com


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


#############ubuntuLinux config begin###############
config_apt_source()
{
    if [ -e /etc/apt/sources.list ]; then
        mv /etc/apt/sources.list  /etc/apt/sources.list.bak
    fi

cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
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
    apt install bash-completion  nload  lrzsz iptraf-ng dstat  nethogs sysstat iftop iotop net-tools  -y

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

 config_ubuntu_ssh() 
 {
    sed -ri 's/^#(PermitRootLogin) .*/\1 yes/' /etc/ssh/sshd_config
    sed -ri 's/^#(UseDNS) .*/\1 no/' /etc/ssh/sshd_config
    sed -ri 's/^#(GSSAPIAuthentication) .*/\1 no/' /etc/ssh/sshd_config
    echo "root:123456" | chpasswd
    systemctl restart sshd.service
    print_message "config_ubuntu_ssh"
 }

 config_ubuntu_mail() 
{
    apt update
    apt install s-nail
    cat >> /etc/s-nail.rc <<EOF
set from=$QQ_MAIL_FROM
set smtp=smtp.qq.com
set smtp-auth-user=$QQ_MAIL_FROM
set smtp-auth-password=$AUTH_PASSWORD
set smtp-auth=login
EOF
    echo "this is a test mail from ubuntu" | s-nail -s "test"  "$TEST_MAIL"
    print_message "ubuntu mail config"
}

set_ps1_ubuntu()
{
    cat >> /root/.bashrc <<EOF
PS1='\[\e[1;31m\][\t \u@\h \W]\[\e[0m\]$ '
EOF
}


config_ntp() 
{
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
    print_message "NTP config" 
}

#############ubuntu config end######################

reset_main() 
{
    config_apt_source
    config_ubuntu_vim
    ubuntu_install_common_app
    config_ubuntu_mail
    config_ntp
    config_ubuntu_ssh
    ubuntu_config_network
    ubuntu_config_timezone
    hostnamectl set-hostname "$UBUNTU_HOSTNAME"
    print_message "set-hostname"
    sed -ri "/^127.0.1.1/s/^.*$/127.0.0.1 ${UBUNTU_HOSTNAME}/" /etc/hosts
    set_ps1_ubuntu
    echo "reboot....."
    reboot
}

reset_main




