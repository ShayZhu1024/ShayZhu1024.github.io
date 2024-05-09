#!/bin/bash

#color output #1:color  #2:content
colorOutput() 
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
printMessage() {

    if (($? == 0)); then
        local space=$((80-${#1}))
        echo -n  "$1"
        printf "%${space}s\n"  "$(colorOutput green "[success]")"
    else 
        local space=$((80-${#1}))
        echo -n  "$1"
        printf "%${space}s\n"  "$(colorOutput red "[failed]")"
        exit 1
    fi
}
