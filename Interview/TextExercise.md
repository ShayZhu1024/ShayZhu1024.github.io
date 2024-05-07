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


### 6.取两个文件相同的行
	`egrep -f /data/f1.txt  /data/f2.txt`
	`paste /data/f1.txt /data/f2.txt | sort | uniq -d`

### 7.处理器核心个数
	`egrep -c processor /proc/cpuinfo`
	
### 8.算出所有人的年龄总和
```bash
[root]#cat age.txt 
xiaoming=20
xiaohong=18
xiaoqiang=22

cut -d= -f2 ./age.txt | paste -s -d+ | bc
cut -d"=" -f2 ./age.txt|tr '\n' + | grep -Eo ".*[0-9]"|bc

```

### 9.12-1点日志
```bash
/var/log/message
sed -n  '/^Apr 12 12/,/^Apr 19 13/p' /var/log/messages
sed -n -e '/^Apr 12 12/p'  -e '/^Apr 12 13/p' /var/log/messages
sed -n '/^Apr 12 12/p;/^Apr 12 13/p' /var/log/messages
```

### 10.df找出分区利用率
```bash
df | sed -En  '/^\/dev\/.*/s/^.* +([0-9]?[0-9]?)%.*/\1/p' | sort -nr
df | sed -En  's/^\/dev\/.* +([0-9]+)%.*/\1/p' | sort -nr
```



