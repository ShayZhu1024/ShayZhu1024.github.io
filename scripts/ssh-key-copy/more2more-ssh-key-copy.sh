#!/bin/bash

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


DEST_HOST_IPS="
10.0.0.4
10.0.0.5
10.0.0.100
10.0.0.101
"
HOST_PUB_RSA_KEY=$HOME/.ssh/id_rsa.pub

if [ ! -e "$HOST_PUB_RSA_KEY" ]; then
    ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa &>/dev/null
fi

yum install sshpass -y &>/dev/null

sshpass -p 123456 ssh-copy-id -o StrictHostKeyChecking=no  127.0.0.1  &>/dev/null

print_message "env prepared"

for HOST_IP in $DEST_HOST_IPS; do 
    sshpass -p 123456 scp -o StrictHostKeyChecking=no -r $HOME/.ssh "$HOST_IP": &>/dev/null
    print_message "$HOST_IP"
done

print_message "all host copy finished"
