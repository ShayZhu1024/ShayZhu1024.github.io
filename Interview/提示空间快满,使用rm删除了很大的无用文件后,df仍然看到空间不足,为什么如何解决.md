因为被删除文件有程序占用，导致系统无法释放文件的空间

cat /dev/null > /path/bigfile
rm -f /path/bigfile

如果提前删除了文件，还在占用
lsof | grep delete  #查看删除文件
ps aux  #找到占用程序
kill 1456  #删除对应程序

最好用上面方法