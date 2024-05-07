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

### 11 通配符或者正则

1、显示/etc目录下所有以l开头，以一个小写字母结尾，且中间出现至少一位数字的文件或目录列表

2、显示/etc目录下以任意一位数字开头，且以非数字结尾的文件或目录列表

3、显示/etc/目录下以非字母开头，后面跟了一个字母及其它任意长度任意字符的文件或目录列表

4、显示/etc/目录下所有以rc开头，并后面是0-6之间的数字，其它为任意字符的文件或目录列表

5、显示/etc目录下，所有.conf结尾，且以m,n,r,p开头的文件或目录列表

6、只显示/root下的隐藏文件和目录列表

7、只显示/etc下的非隐藏目录列表

8、显示/proc/meminfo文件中以大小s开头的行(要求：使用两种方法) 

9、显示/etc/passwd文件中不以/bin/bash结尾的行

10、显示用户rpc默认的shell程序

11、找出/etc/passwd中的两位或三位数

12、显示CentOS7的/etc/grub2.cfg文件中，至少以一个空白字符开头的且后面有非空白字符的行

13、找出“netstat -tan”命令结果中以LISTEN后跟任意多个空白字符结尾的行

14、显示CentOS7上所有UID小于1000以内的用户名和UID 

15、添加用户bash、testbash、basher、sh、nologin(其shell为/sbin/nologin),找出/etc/passwd用户名和shell同名的行

16、利用df和grep，取出磁盘各分区利用率，并从大到小排序

17 显示三个用户root、mage、wang的UID和默认shell 

18 找出/etc/rc.d/init.d/functions文件中行首为某单词(包括下划线)后面跟一个小括号的行

19 使用egrep取出/etc/rc.d/init.d/functions中其基名

20 使用egrep取出上面路径的目录名

21 统计last命令中以root登录的每个主机IP地址登录次数

22 利用扩展正则表达式分别表示0-9、10-99、100-199、200-249、250-255 

23 显示ifconfig命令结果中所有IPv4地址2将此字符串：welcome to magedu linux 中的每个字符去重并排序，重复次数多的排到前面

24、删除centos7系统/etc/grub2.cfg文件中所有以空白开头的行行首的空白字符

25、删除/etc/fstab文件中所有以#开头，后面至少跟一个空白字符的行的行首的#和空白字符

26、在centos6系统/root/install.log每一行行首增加#号

27、在/etc/fstab文件中不以#开头的行的行首增加#号

28、处理/etc/fstab路径,使用sed命令取出其目录名和基名

29、利用sed 取出ifconfig命令中本机的IPv4地址

30、统计centos安装光盘中Package目录下的所有rpm文件的以.分隔倒数第二个字段的重复次数

31、统计/etc/init.d/functions文件中每个单词的出现次数，并排序（用grep和sed两种方法分别实现）

32、将文本文件的n和n+1行合并为一行，n为奇数行




### 11 每天将/etc/目录下所有文件，备份到/data独立的子目录下，并要求子目录格式为 backupYYYYmm-dd，备份过程可见




### 12 创建/data/rootdir目录，并复制/root下所有文件到该目录内，要求保留原有权限


### 13 为所有的f开头包含conf的文件加上.bak后缀：



### 14 #去掉所有的bak后缀：

### 15 如何创建/testdir/dir1/x, /testdir/dir1/y, /testdir/dir1/x/a, /testdir/dir1/x/b, /testdir/dir1/y/a, /testdir/dir1/y/b


### 16 如何创建/testdir/dir2/x, /testdir/dir2/y, /testdir/dir2/x/a, /testdir/dir2/x/b


### 17 如何创建/testdir/dir3, /testdir/dir4, /testdir/dir5, /testdir/dir5/dir6, /testdir/dir5/dir7










