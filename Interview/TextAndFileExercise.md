### 1、找出ifconfig “网卡名” 命令结果中本机的IPv4地址
```bash
ifconfig ens160 | head -n2 | tail -n1 | tr -s " "|cut -d " " -f3
ifconfig eth0 | sed -rn '2s/ +inet +([^ ]*) +netmask.*/\1/p'
ifconfig eth0 | awk 'NR==2{print $2}'
```

### 2、查出分区空间使用率的最大百分比值
```bash
df | tail -n +2 | tr -s " "|cut -d" " -f 5|tr -d "%"|sort -nr|head -n1
df  | sed -rn '/^\/dev.*/s#.* +([[:digit:]]+)%.*#\1#p'|sort -nr|head -n 1
df | awk '/^\/dev/ {print substr($5,1,length($5)-1)}' | sort -nr | head -n1
```

### 3、查出用户UID最大值的用户名、UID及shell类型
```bash
cat /etc/passwd | cut -d":" -f3,1,7|sort -t: -k2 -nr|head -n1
awk -v FS=:  -v OFS=' ' '{print $1,$3,$7 }' /etc/passwd | sort -t" " -k2 -nr | head -n1
```

### 4、查出/tmp的权限，以数字方式显示
```bash
stat /tmp/ | head -n4 | tail -n1 | cut -d" " -f2 | tr -d "()"|cut -d/ -f1
stat /tmp/ | sed -rn 's/Access: +\(([0-9]+)\/.*/\1/p'

```

### 5、统计当前连接本机的每个远程主机IP的连接数，并按从大到小排序
```bash
ss -nt | awk  'NR>=2{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr

```

### 6.取两个文件相同的行
```bash
egrep -o  -f a.txt  b.txt
cat a.txt b.txt | sort  | uniq -d
```

### 7.处理器核心个数
```bash
egrep -c "processor" <(cat /proc/cpuinfo)
lscpu | awk  '/^CPU\(s\):/{print $2}'

```
	
### 8.算出所有人的年龄总和
```bash
[root]#cat age.txt 
xiaoming=20
xiaohong=18
xiaoqiang=22

cut -d= -f2 ./age.txt | paste -s -d+ | bc
cut -d"=" -f2 ./age.txt|tr '\n' + | grep -Eo ".*[0-9]"|bc
awk -F=  '{print $2}' ./age.txt | paste -s -d "+" | bc
awk -F= -v ORS='+' '{print $2}' ./age.txt  | egrep  -o '^.*[0-9]' | bc
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

### 11 通配符或者正则, 使用文本三剑客或者其他文本处理工具

1、显示/etc目录下所有以l开头，以一个小写字母结尾，且中间出现至少一位数字的文件或目录列表
```bash
ls -d  /etc/l*[0-9]*[[:lower:]]
ls -a /etc/ | egrep '^l.*[0-9]+.*[a-z]$'
```

2、显示/etc目录下以任意一位数字开头，且以非数字结尾的文件或目录列表
```bash
ls -d /etc/[0-9]*[^0-9]
ls -a /etc | egrep '^[0-9].*[^0-9]$'
```
3、显示/etc/目录下以非字母开头，后面跟了一个字母及其它任意长度任意字符的文件或目录列表
```bash
ls -d /etc/[^a-z][a-z]*
ls -a /etc/ | egrep '^[^[:alpha:]][[:alpha:]].*'
```

4、显示/etc/目录下所有以rc开头，并后面是0-6之间的数字，其它为任意字符的文件或目录列表
```bash
ls -d /etc/rc[0-6]*
ls -a /etc/ | egrep '^rc[0-6].*'
```

5、显示/etc目录下，所有.conf结尾，且以m,n,r,p开头的文件或目录列表
```bash
ls -d /etc/[mnrp]*.conf
ls -a /etc | egrep '^[mnrp].*\.conf$'
```

6、只显示/root下的隐藏文件和目录列表
```bash
ls -d /root/.[^.]*  /root/*/
ls -aF /root/ | egrep '^\.[^./].*$|^[^.].*/'

```

7、只显示/etc下的非隐藏目录列表
```bash
ls -d /etc/[^.]*/
ls -F  /etc/ | egrep '^.*/'
```

9、显示/etc/passwd文件中不以/bin/bash结尾的行
```bash
egrep -v '^.*/bin/bash$'  /etc/passwd
```

10、显示用户rpc默认的shell程序
```bash
sed -rn  's/^rpc.*:(.*)/\1/p' /etc/passwd
```

11、找出/etc/passwd中的两位或三位数
```bash
egrep -o '[0-9]{2,3}' /etc/passwd
```

12、显示CentOS7的/etc/grub2.cfg文件中，至少以一个空白字符开头的且后面有非空白字符的行
```bash
egrep '^ +[^ ]*' /etc/grub2.cfg
```

13、找出“netstat -tan”命令结果中以LISTEN后跟任意多个空白字符结尾的行
```bash
egrep  '.*LISTEN *' <(netstat -tan)
```

14、显示CentOS7上所有UID小于1000以内的用户名和UID 
```bash
awk -F: '$3<1000{print $1,$3}' /etc/passwd
```

15、找出/etc/passwd用户名和shell同名的行
```bash
tr ":/" " " < /etc/passwd | awk  '$1==$NF{print $0}'
```

17 显示三个用户root、halt、shay的UID和默认shell 
```bash
awk -F:  '$1=="root"||$1=="halt"||$1=="shay"{print $1,$3,$NF}' /etc/passwd

```

18 找出/etc/rc.d/init.d/functions文件中行首为某单词(包括下划线)后面跟一个小括号的行
```bash
cat /etc/rc.d/init.d/functions | egrep '^[0-9a-zA-Z_]+\(\)'
```

19 使用egrep取出/etc/rc.d/init.d/functions中其基名
```bash
egrep -o '[a-zA-Z0-9_-]+$' <<<'/etc/rc.d/init.d/functions'
```

20 使用egrep取出上面路径的目录名
```bash
egrep -o '^.*/' <<<'/etc/rc.d/init.d/functions'
```

21 统计last命令中以root登录的每个主机IP地址登录次数
```bash
last | awk '$1=="root"{print $3}' | sort | uniq -c
```

22 利用扩展正则表达式分别表示0-9、10-99、100-199、200-249、250-255 
```bash
[0-9]
[1-9][0-9]
1[0-9][0-9]
2[0-4][0-9]
25[0-5]
```

23 1.显示ifconfig命令结果中所有IPv4地址2.将此字符串：welcome to magedu linux 中的每个字符去重并排序，重复次数多的排到前面
```bash
ifconfig | egrep -o "[0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]?"
egrep -o '[a-z]' <<< "welcome to magedu linux" | sort | uniq -c | sort -nr
```

24、删除centos7系统/etc/grub2.cfg文件中所有以空白开头的行行首的空白字符
```bash
sed -ri 's/^ +([^ ]+)/\1/' /etc/grub2.cfg
```

25、删除/etc/fstab文件中所有以#开头，后面至少跟一个空白字符的行的行首的#和空白字符
```bash
sed -ri 's/^# +([^ ]+)/\1/' /etc/fstab
```

26、在centos6系统/root/install.log每一行行首增加#号
```bash
sed -ri 's/^/#/' /root/install.log
```

27、在/etc/fstab文件中不以#开头的行的行首增加#号
```bash
sed -ri 's/(^[^#].*)/#\1/' /etc/fstab
```

28、处理/etc/fstab路径,使用sed命令取出其目录名和基名
```bash
目录名：sed -rn 's#^(/[^ ]+) +.*#\1#p' /etc/fstab  | sed -rn 's#/(([^/]+/)+)(.*)#/\1#p'
基名： sed -rn 's#^(/[^ ]+) +.*#\1#p' /etc/fstab  | sed -rn 's#/(([^/]+/)+)(.*)#\3#p'
```

29、利用sed 取出ifconfig命令中本机的IPv4地址
```bash
ifconfig | sed -rn 's#^ +inet +([0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]?\.[0-2]?[0-9]?[0-9]) +.*?#\1#p'
```

30、统计centos安装光盘中Package目录下的所有rpm文件的以.分隔倒数第二个字段的重复次数
```bash
ls /mnt/Packages  | awk -F. '{print $(NF-1)}' | sort | uniq -c
```

31、统计/etc/init.d/functions文件中每个单词的出现次数，并排序
```bash
egrep -o '[a-zA-Z0-9_]+' /etc/init.d/functions  | sort  | uniq -c | sort -nr
```

32、将文本文件的n和n+1行合并为一行，n为奇数行
```bash
awk '{if(NR % 2 != 0) {printf "%s ", $0} else {print $0}}' ./file.txt
```

33、文件host_list.log 如下格式，请提取”.magedu.com”前面的主机名部分并写入到回到该文件中
```bash
www.magedu.com
blog.magedu.com
study.magedu.com
linux.magedu.com
python.magedu.com

awk -F. '{print $1}' ./host_list.log  >> host_list.log
```
34、统计/etc/fstab文件中每个文件系统类型出现的次数
```bash
awk '/^[^#]/{print $3}'  /etc/fstab  | sort | uniq -c
```

36、提取出字符串Yd$C@M05MB%9&Bdh7dq+YVixp3vpw中的所有数字
```bash
egrep -o '[0-9]' <<<"Yd$C@M05MB%9&Bdh7dq+YVixp3vpw"
```

37、 文件random.txt记录共5000个随机的整数，存储的格式100,50,35,89…请取出其中最大和最小的整
数
```bash
tr ',' '\n'  < random.txt  | sort -nr | head -n 1
tr ',' '\n'  < random.txt  | sort -nr | tail -n 1
```


39、将以下文本文件awktest.txt中 以inode列为标记，对inode列相同的counts列进行累加，并且统计
出同一inode中，beginnumber列中的最小值和endnumber列中的最大值

```bash
inode|beginnumber|endnumber|counts|
106|3363120000|3363129999|10000|
106|3368560000|3368579999|20000|
310|3337000000|3337000100|101|
310|3342950000|3342959999|10000|
310|3362120960|3362120961|2|
311|3313460102|3313469999|9898|
311|3313470000|3313499999|30000|
311|3362120962|3362120963|2|



awk -F'|' '
NR > 1 { 
  inode = $1; 
  begin = $2; 
  end = $3; 
  count = $4; 

  # 累加 counts 值
  counts[inode] += count; 

  # 更新最小 beginnumber
  if (!minbegin[inode] || begin < minbegin[inode]) {
    minbegin[inode] = begin;
  }

  # 更新最大 endnumber
  if (!maxend[inode] || end > maxend[inode]) {
    maxend[inode] = end;
  }
}
END {
  # 输出最终结果
  print "inode|minbeginnumber|maxendnumber|totalcounts|";
  for (i in counts) {
    print i "|" minbegin[i] "|" maxend[i] "|" counts[i] "|";
  }
}' awktest.txt
```

### 文件查找

1、查找/var目录下属主为root，且属组为mail的所有文件

2、查找/var目录下不属于root、lp、gdm的所有文件

3、查找/var目录下最近一周内其内容修改过，同时属主不为root，也不是postfix的文件

4、查找当前系统上没有属主或属组，且最近一个周内曾被访问过的文件

5、查找/etc目录下大于1M且类型为普通文件的所有文件

6、查找/etc目录下所有用户都没有写权限的文件

7、查找/etc目录下至少有一类用户没有执行权限的文件

8、查找/etc/init.d目录下，所有用户都有执行权限，且其它用户有写权限的文件










11 每天将/etc/目录下所有文件，备份到/data独立的子目录下，并要求子目录格式为 backupYYYYmm-dd，备份过程可见




12 创建/data/rootdir目录，并复制/root下所有文件到该目录内，要求保留原有权限


13 为所有的f开头包含conf的文件加上.bak后缀：



14 #去掉所有的bak后缀：

15 如何创建/testdir/dir1/x, /testdir/dir1/y, /testdir/dir1/x/a, /testdir/dir1/x/b, /testdir/dir1/y/a, /testdir/dir1/y/b


16 如何创建/testdir/dir2/x, /testdir/dir2/y, /testdir/dir2/x/a, /testdir/dir2/x/b


17 如何创建/testdir/dir3, /testdir/dir4, /testdir/dir5, /testdir/dir5/dir6, /testdir/dir5/dir7










