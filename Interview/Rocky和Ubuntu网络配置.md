简述 TCP/IP三次握手和四次挥手的工作原理?


使用tcpdump 监听主机为192.168.1.1,tcp端口为80的数据,同时将输出结果保存成文件?
```bash
tcpdump -nn tcp port 80 and host 192.168.1.1 -w ./out.cap

```

写一个扫描某个主机端口的状态的脚本
```bash
#!/bin/bash             
                        
IP=$1                   
                        
rpm -q nmap-ncat &>/dev/null ||  { yum install nmap-ncat -y &>/dev/null; nc install finished!; }
                        
echo "scan start !!!!"                                                                                                                
for ((i=1; i<=65535; ++i)); do
    nc -z  $IP  $i && { echo "$i is up"; } & 
done                    
                        
wait 

```