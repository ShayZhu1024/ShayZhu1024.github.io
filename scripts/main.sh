#!/bin/bash


source ./common.sh
source ./reset.sh

MENUS="初始化系统 退出"
PS3="选择(1-6):"
select MENU in $MENUS; do
    case "${REPLY}" in
        1)
            resetMain
            ;;
        2)
            break
            ;;
        *)
            echo "不存在的操作，重新选择"
        ;;
    esac
    
done
