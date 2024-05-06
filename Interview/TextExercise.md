### 1、找出ifconfig “网卡名” 命令结果中本机的IPv4地址
`ifconfig ens160 | head -n2 | tail -n1 | tr -s " "|cut -d " " -f3`

### 2、查出分区空间使用率的最大百分比值
`df | tail -n +2 | tr -s " "|cut -d" " -f 5|tr -d "%"|sort -nr|head -n1`

### 3、查出用户UID最大值的用户名、UID及shell类型
`cat /etc/passwd | cut -d":" -f3,1,7|sort -t: -k2 -nr|head -n1`

### 4、查出/tmp的权限，以数字方式显示
`stat /tmp/ | head -n4 | tail -n1 | cut -d" " -f2 | tr -d "()"|cut -d/ -f1`

### 5、统计当前连接本机的每个远程主机IP的连接数，并按从大到小排序
`who | tr -s " " | cut -d " "  -f5|tr -d "()"|sort|uniq -c|tr -s " "|sort -t " " -k2 -nr`

