1、编写脚本 systeminfo.sh，显示当前主机系统信息，包括:主机名，IPv4地址，操作系统版本，内核版本，CPU型号，内存大小，硬盘大小

```bash
#!/bin/bash

HOST_NAME=`hostname`
IPV4_ADDR=`hostname -I`
OS_VERSION=`sed -rn '/^PRETTY_NAME="/s/^.*"(.*)"/\1/p' /etc/os-release`
KERNEL_VERSION=`uname -r`
CPU_TYPE=`lscpu  | sed -rn "s/^Model name: +(.*)$/\1/p"`
MEMORY=`free -h | awk 'NR==2{print $2}'`
DISK=`lsblk | awk '/^sd.*/{print $1,$4}'`

echo "HOST_NAME:${HOST_NAME}"
echo "IPV4_ADDR:${IPV4_ADDR}"
echo "OS_VERSION:${OS_VERSION}"
echo "KERNEL_VERSION:${KERNEL_VERSION}"
echo "CPU_TYPE:${CPU_TYPE}"
echo "MEMORY:${MEMORY}"
echo "DISK:${DISK}"

```

2、编写脚本 backup.sh，可实现每日将 /etc/ 目录备份到 /backup/etcYYYY-mm-dd中

```bash
#!/bin/bash
if [ ! -e /backup ]; then 
    mkdir -p /backup
fi
cp -a  /etc/   /backup/etc`date +%F`

```

3、编写脚本 disk.sh，显示当前硬盘分区中空间利用率最大的值

```bash
#!/bin/bash
echo "max is `df | awk '/^\/dev.*/{print $5}' | sort -nr | head -n1`"
```

4、编写脚本 links.sh，显示正连接本主机的每个远程主机的IPv4地址和连接数，并按连接数从大到小排序

```bash
#!/bin/bash

ss -t  | awk  '/^ESTAB/{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
```

5、 查看指定进程的环境变量
```bash
cat /proc/$PID/environ  # PID 是自己定义的变量，不是系统环境变量
```


6 鸡兔同笼，是中国古代著名典型趣题之一，记载于《孙子算经》之中。今有雉兔同笼，上有三十五头，下有九十四足，问雉兔各几何？
```bash
#!/bin/bash            
                       
HEADS=$1               
FEET=$2                
RABBITS=$((($FEET-$HEADS*2)/2))
CHICKENS=$(($HEADS-$RABBITS))
                       
echo "rabbits: $RABBITS"
echo "chickens: $CHICKENS" 
```

7.编写脚本 argsnum.sh，接受一个文件路径作为参数；如果参数个数小于1，则提示用户“至少应该给一个参数”，并立即退出；如果参数个数不小于1，则显示第一个参数所指向的文件中的空白行数
```bash
#!/bin/bash

(($# < 1)) && { echo "至少应该给一个参数"; exit 1; }
FILE_DIR=$1
if [ ! -e $FILE_DIR ]; then
    echo "文件不存在"
    exit 1
elif [ ! -f $FILE_DIR ]; then
    echo "文件不是普通文件, 无法打开"
    exit 1
fi

COUNT=`egrep -c  '^$'  "$FILE_DIR"`

echo "$FILE_DIR文件的空白行数是：$COUNT"

```

8、编写脚本 hostping.sh，接受一个主机的IPv4地址做为参数，测试是否可连通。如果能ping通，则提示用户“该IP地址可访问”；如果不可ping通，则提示用户“该IP地址不可访问”
```bash
#!/bin/bash               
                          
(($# < 1)) && { echo "需要一个IPV4地址作为参数"; exit 1; }
                          
IP=$1                     
                          
if ping -c1 $IP &>/dev/null; then
    echo "$IP 可以访问"
else                      
    echo "$IP 不可访问"                                                           
fi 

```

9、编写脚本 checkdisk.sh，检查磁盘分区空间和inode使用率，如果超过80%，就发广播警告空间将满
```bash
#!/bin/bash                       
                                  
DISK_USED=`df | awk  '/^\/dev/{print $5}'  |tr -d "%" |sort -nr | head -n1`
INODE_USED=`df -i  | awk  '/^\/dev/{print $5}'  |tr -d "%" |sort -nr | head -n1`
                                  
if ((DISK_USED >= 80)); then   
    echo "disk space used exceed  80%" | wall &>/dev/null
elif ((INODE_USED >= 80)); then                                                                                                       
     echo "disk inode used exceed 80%" | wall &>/dev/null
fi 

```

10、编写脚本 per.sh，判断当前用户对指定参数文件，是否不可读并且不可写
```bash
#!/bin/bash
  
(($#<1)) && { echo "need 1 arg"; exit; }
FILE=$1
if [ ! -r $FILE -a ! -w $FILE  ]; then
    echo "yes, $USER can't read and write $FILE"
elif [ -r $FILE ]; then
    echo "No, $USER can read $FILE"
elif [ -w $FILE ]; then
    echo "No, $USER can write $FILE"
fi  

```

11、编写脚本 excute.sh ，判断参数文件是否为sh后缀的普通文件，如果是，添加所有人可执行权限，否则提示用户非脚本文件
```bash
#!/bin/bash                          
                                     
(($#<1)) && { echo "need 1 arg"; exit; }
                                     
FILE=$1                              
                                     
if [ -f $1 ] && [[ $1 =~ ^.*\.sh$ ]]; then
    chmod +x $FILE                   
else                                 
    echo "$FILE is not script file"                                               
fi 
```

12、编写脚本 nologin.sh和 login.sh，实现禁止和允许普通用户登录系统
```bash
#nologin.sh
#!/bin/bash
if [ ! -e /etc/nologin ]; then
    touch /etc/nologin
fi

#login.sh
if [ -e /etc/nologin ]; then
    rm -rf /etc/nologin
fi

```

13、让所有用户的PATH环境变量的值多出一个路径，例如：/usr/local/apache/bin
```bash
#!/bin/bash

PATH+=:/usr/local/apache/bin
export PATH


# 执行这个脚本使用 source  ./script.sh生效
#或则把这个脚本放到 /etc/profile.d目录下

```
14
```bash
用户 root 登录时，将命令指示符变成红色，并自动启用如下别名： 
rm=‘rm -i’
cdnet=‘cd /etc/sysconfig/network-scripts/’
editnet=‘vim /etc/sysconfig/network-scripts/ifcfg-eth0’
editnet=‘vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 或 ifcfg-ens33 ’ (如果系统是
CentOS7)
```

```bash
#!/bin/bash

if [ $USER = root ]; then
    PS1='\[\e[1;31m\][\t \u@\h \W]\[\e[0m\]$ '
    alias rm='rm -i'
    alias cdnet='cd /etc/sysconfig/network-scripts/'
    alias editnet='vim /etc/sysconfig/network-scirpts/ifcfg-eth0'
fi

#把这个脚本放到/etc/profile.d目录下
```


15、任意用户登录系统时，显示红色字体的警示提醒信息“Hi,dangerous！”
```bash
#!/bin/bash

echo -e "\e[31;1mHi,dangerous!\e[0m"

#此脚本放到 /etc/profile.d目录下

```

16、编写生成脚本基本格式的脚本，包括作者，联系方式，版本，时间，描述等
```bash
#!/bin/bash
cat >> /etc/vimrc <<EOF
        call setline(1, "\#!/bin/bash")
        call setline(2, "################################")
        call setline(3, "# Author: ShayZhu")                
        call setline(4, "# Contact: shayzhu@126.com")       
        call setline(5, "# Version: 1.0.0")                 
        call setline(6, '# Date: ' . strftime('%Y-%m-%d'))
        call setline(7, '# Description:')                   
        call setline(8, '################################')                                     
        call setline(9, '')                                 
        call setline(10, '')
EOF

```


17、编写脚本 createuser.sh，实现如下功能：使用一个用户名做为参数，如果指定参数的用户存在，就显示其存在，否则添加之。并设置初始密码为123456，显示添加的用户的id号等信息，在此新用户第一次登录时，会提示用户立即改密码，如果没有参数，就提示：请输入用户名

```bash
#!/bin/bash

(($#<1)) && { echo "need a user name as a arg"; exit; }
                                     
NAME=$1                                 
                                        
if getent passwd $NAME &>/dev/null; then
    echo "$NAME is exist!!!"            
else                                    
    useradd  "$NAME"                    
    echo "$NAME:123456" | chpasswd   
    passwd --expire $NAME &>/dev/null                                                           
    id $NAME                            
fi 
```

18、编写脚本 yesorno.sh，提示用户输入yes或no,并判断用户输入的是yes还是no,或是其它信息

```bash
#!/bin/bash

(($# < 1)) && { echo "need 1 arg"; exit 1; }
 
INPUT=`tr '[[:upper:]]' '[[:lower:]]' <<< "$1" `
                                                                                                
case $INPUT in
    yes|y)
        echo "user input is yes!"
        ;;  
    n|no)
        echo "user input is no!"
        ;;  
    *)  
        echo "user input is other"
        ;;  
esac

```

19、编写脚本 filetype.sh，判断用户输入文件路径，显示其文件类型（普通，目录，链接，其它文件类型）
```bash
#!/bin/bash

(($#<1)) && { echo "need 1 filepath argument"; exit; }
 
FILE_PATH=$1
 
if [ -h $FILE_PATH ]; then
    echo "$FILE_PATH is a link file"
elif [ -d $FILE_PATH ]; then
    echo "$FILE_PATH is directory"
elif [ -f "$FILE_PATH" ]; then
    echo "$FILE_PATH" is rugular  file
else                                                                                            
    echo "$FILE_PATH is other file "
fi

```

20、编写脚本 checkint.sh，判断用户输入的参数是否为正整数
```bash
                                             
(($#<1)) && { echo "need 1 number arg"; exit; }
                                             
NUM=$1                                       
                                             
if [[ $NUM =~ ^\+?[0-9]+$ ]] && ((NUM != 0)); then                                                             
    echo "yes! $NUM is positive integer " 
else                                         
    echo "no!! $NUM is not positive integer "
fi  
```

23 面试题，计算1+2+3+...+100 的结果
```bash
#!/bin/bash

(($#<1)) && { echo "need 1 positive integer arg"; exit; }

NUM=$1

SUM=$(echo `seq -s+ 1  $1 ` | bc)

echo "1+2+3...$NUM = $SUM"
```

24 100以内的奇数之和
```bash
#!/bin/bash

(($#<1)) && { echo "need 1 positive integer arg"; exit; }

NUM=$1
SUM=0
for ((i=1; i < $NUM; ++i)); do
    if ((i%2==1)); then
        ((SUM+=i))
    fi
done

echo "odd sum between $NUM and 1 ： $SUM"
```

25  九九乘法表
```bash
#!/bin/bash

for ((row=1; row<=9; ++row)); do
    for ((column=1;column<=row;++column)); do
        printf "%-12s"  "${column} x ${row} = $((column*row))"                                                                        
    done               
    echo               
done  
```

26 将指定目录下的文件所有文件的后缀改名为 bak 后缀
```bash
#!/bin/bash

(($#<2)) && { echo -e  "uage: <dir> <suffix>  [<--all>]\n --all:包括隐藏文件，缺省:不包括隐藏文件"; exit 1; }
 
DIR=$1
SUFFIX=$2
MODE=$3
 
 
if [ ! -d "$DIR" -o "$MODE" != "--all" -a "$MODE" != "" ]; then
    echo "arg error!!!!"
    exit 1
fi
 
if [ "$MODE" = "--all" ]; then
    for file in `ls -A $DIR/`; do
        mv "$DIR/$file"  "${DIR}/${file%.*}.${SUFFIX#*.}"
    done                                                                                                                              
elif [ "$MODE" = "" ]; then
    for file in $DIR/*; do
        mv "$file"  "${file%.*}.${SUFFIX#*.}"
    done
fi
```

27 要求将目录YYYY-MM-DD/中所有文件，移动到YYYY-MM/DD/下

```bash
#!/bin/bash

DIR1=$1
DIR2=$2

mkdir -p "$DIR2"

cp -a "$DIR1/*"  "$DIR2"
```

28 扫描一个网段：10.0.0.0/24，判断此网段中主机在线状态，将在线的主机的IP打印出来
```bash
#!/bin/bash

IP=10.0.0.0                                                
                                                           
for i in {1..254}; do                                      
   { ping -c1 "${IP%.*}.$i" &>/dev/null && echo "${IP%.*}.$i is up" ; } &                                      
done                                                       
                                                           
wait 

```

29 有若干只兔和鸡，兔和鸡加起来一共有100条腿，请写一个简单的shell算出兔和鸡各多少只可能组合(假设所有的羊和鸡的腿都是健全的，且兔和鸡至少为1只)
```bash
#!/bin/bash

                                    
LEGS=100                            
for((rabbit=1; 4*rabbit <= 98; ++rabbit)); do
    if (((100 - rabbit * 4) % 2 == 0)); then
        ((possibles+=1))            
        echo "rabbits:${rabbit}, chickens:$(((100 - rabbit * 4) / 2))"
    fi                              
done                                
                                    
echo "total possibles: $possibles" 

```

30 等腰三角形
```bash
#!/bin/bash

(($#<1)) && { echo "need 1 arg"; exit; }
LEVEL=$1 
for((i=1; i <= LEVEL; ++i)); do
    for ((j=1; j <= LEVEL - i; ++j)); do
        echo -n " "
    done 
    for ((k=1; k<=i; ++k )); do
        echo -n "* "
    done 
    echo                                                                                                       
done 

```

31 生成进度
```bash
#!/bin/bash


for ((i = 1; i <= 100; ++i)); do
    echo -n "["
    for ((j=1; j <= i; ++j)); do
         echo -n "#"
    done          
    for ((k=1; k<=100-i;++k)); do
        echo -n " "                                                                                            
    done       
    echo -n "]"
    printf "%+4s" "$i%"
    sleep 0.1  
    echo -en "\r"
done           
echo 
```

32、判断/var/目录下所有文件的类型
```bash
#!/bin/bash
 
DIR=/var/

for FILE_PATH in $DIR/*; do 
    if [ -h $FILE_PATH ]; then
        echo "$FILE_PATH is a link file"
    elif [ -d $FILE_PATH ]; then
        echo "$FILE_PATH is directory"
    elif [ -f "$FILE_PATH" ]; then
        echo "$FILE_PATH" is rugular  file
    elif [ -p "$FILE_PATH" ]; then                                                                                            
        echo "$FILE_PATH is pipe file "
    elif [ -b "$FILE_PATH" ]; then   
        echo "$FILE_PATH is block device file "
    elif [ -c "$FILE_PATH" ]; then   
        echo "$FILE_PATH is character device file "
    elif [ -S "$FILE_PATH" ]; then   
        echo "$FILE_PATH is socket file "
    else
        echo "$FILE_PATH is other file "
    fi
done

```

33、添加10个用户user1-user10，密码为8位随机字符
```bash
#!/bin/bash
                                     
for NAME in user{1..10}; do
    if getent passwd $NAME &>/dev/null; then
        echo "$NAME is exist!!!"            
    else                                    
        useradd  "$NAME"
        PASSWD=$(cat  /dev/urandom  | tr -dc '[[:alnum:],./?;)(*&%$#@!~)-]' | head -c8)    
        echo "$NAME:$PASSWD" | tee -a  ./addUsers.txt |  chpasswd   
        passwd --expire $NAME &>/dev/null                                                           
        id $NAME                            
    fi 
done
```


33、/etc/rc.d/rc3.d目录下分别有多个以K开头和以S开头的文件；分别读取每个文件，以K开头的输出为文件加stop，以S开头的输出为文件名加start，如K34filename stop S66filename start
```bash

#!/bin/bash

FILE_PATH=/etc/rc.d/rc3.d

for file in $FILE_PATH/*; do
    file=${file##*/}
    if [[ "$file" =~ ^K ]]; then
        echo "${file}stop"
    elif  [[ "$file" =~ ^S ]]; then
        echo "${file}start"
    fi
done

```

38、在/testdir目录下创建10个html文件,文件名格式为数字N（从1到10）加随机8个字母，如：3AbCdeFgH.html
```bash
#!/bin/bash

FILE_PATH=/testdir

mkdir -p "$FILE_PATH"
for i in {1..10}; do
    touch $FILE_PATH/$i$(cat  /dev/urandom  | tr -dc '[[:alpha:]]' | head -c8).html
done
```


39 猴子第一天摘下若干个桃子，当即吃了一半，还不瘾，又多吃了一个。第二天早上又将剩下的桃子吃掉一半，又多吃了一个。以后每天早上都吃了前一天剩下的一半零一个。到第10天早上想再吃时，只剩下一个桃子了。求第一天共摘了多少？

```bash
#!/bin/bash

PEACHES=1                         
for ((i=1; i<=9; ++i)); do        
    ((PEACHES=(PEACHES+1)*2))  
done                              
                                  
echo "totle peaches is $PEACHES"

```


40 后续六个字符串：efbaf275cd、4be9c40b8b、44b2395c46、f8c8873ce0、b902c16c8b、ad865d2f63是通过对随机数变量RANDOM随机执行命令： echo $RANDOM|md5sum|cut -c1-10 后的结果，请破解这些字符串对应的RANDOM值
```bash
#!/bin/bash

#random 范围 0 - 32767
declare -A VALUE=([efbaf275cd]='efbaf275cd' [4be9c40b8b]='4be9c40b8b' [44b2395c46]='44b2395c46' [f8c8873ce0]='f8c8873ce0' [b902c16c8b]='b902c16c8b' [ad865d2f63]='ad865d2f63')
for ((i=0; i<= 32767; ++i)); do
    HASH=`echo $i | md5sum | cut -c1-10`
    if [ "${VALUE[$HASH]}" ]; then
        echo "$i --> $HASH"
    fi
done

#1000 --> ad865d2f63
#3000 --> b902c16c8b
#6000 --> f8c8873ce0
#9000 --> 44b2395c46
#12000 --> 4be9c40b8b
#15000 --> efbaf275cd

```


41、每隔3秒钟到系统上获取已经登录的用户的信息；如果发现用户hacker登录，则将登录时间和主机记录于日志/var/log/login.log中,并退出脚本
```bash
#!/bin/bash
NAME=hacker
LOG_PATH=/var/log/login.log

while true; do
    if who | awk '{print $1}' | egrep "$NAME" &>/dev/null; then
        who | egrep "^hacker"  >> $LOG_PATH
        break
    fi
    sleep 3
done
```


42、随机生成10以内的数字，实现猜字游戏，提示比较大或小，相等则退出
```bash
#!/bin/bash
NUM=$((RANDOM % 10))

while true; do
    read -r -p "your number: " GUESS_NUM
    if ((GUESS_NUM == NUM)); then
        echo "congratulation!!!! The num is $NUM"
        break
    elif ((GUESS_NUM > NUM)); then
        echo "sorry! your num is greater"
    elif ((GUESS_NUM < NUM)); then
        echo "sorry! your num is lower"
    fi
done

```


43、用文件名做为参数，统计所有参数文件的总行数
```bash
#!/bin/bash


```


44、用二个以上的数字为参数，显示其中的最大值和最小值
```bash
#!/bin/bash


```


45、 编写函数，实现OS的版本判断
```bash
#!/bin/bash


```


46、 编写函数，实现取出当前系统eth0的IP地址
```bash
#!/bin/bash


```


47、 编写函数，实现打印绿色OK和红色FAILED
```bash
#!/bin/bash


```


48、 编写函数，实现判断是否无位置参数，如无参数，提示错误
```bash
#!/bin/bash


```


49、 编写函数，实现两个数字做为参数，返回最大值
```bash
#!/bin/bash


```



52、
```bash
斐波那契数列又称黄金分割数列，因数学家列昂纳多·斐波那契以兔子繁殖为例子而引入，故又称为
“兔子数列”，指的是这样一个数列：0、1、1、2、3、5、8、13、21、34、……，斐波纳契数列以
如下被以递归的方法定义：F（0）=0，F（1）=1，F（n）=F(n-1)+F(n-2)（n≥2），利用函数，求
n阶斐波那契数列
```

```bash
#!/bin/bash


```


53、
```bash
汉诺塔（又称河内塔）问题是源于印度一个古老传说。大梵天创造世界的时候做了三根金刚石柱
子，在一根柱子上从下往上按照大小顺序摞着64片黄金圆盘。大梵天命令婆罗门把圆盘从下面开始
按大小顺序重新摆放在另一根柱子上。并且规定，在小圆盘上不能放大圆盘，在三根柱子之间一次
只能移动一个圆盘，利用函数，实现N片盘的汉诺塔的移动步骤

```

```bash
#!/bin/bash


```


54、
编写脚本，定义一个数组，数组中的元素对应的值是/var/log目录下所有以.log结尾的文件；统计
出其下标为偶数的文件中的行数之和

```bash
#!/bin/bash


```
















