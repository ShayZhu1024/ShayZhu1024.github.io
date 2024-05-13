#!/bin/bash


LOCAL_REPO=1
LOCAL_REPO_IP=10.0.0.4



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


reset_main() 
{
    detect_os_version
    if [[ $ID =~ rhel|rocky|centos ]]; then
        disable_selinux
        disable_firewall
        config_yum
    elif [[ $ID =~ ubuntu ]]; then
        echo "ubuntu"
    fi

}


reset_main




