# TLSAN
> The Linux System Administration Notes

<img alt="Static Badge" src="https://img.shields.io/badge/Linux-Shell-blue">&emsp;
<img alt="Static Badge" src="https://img.shields.io/badge/License-MPL--2.0-yellow">&emsp;
<a href="https://hub.docker.com/"  target="_blank"><img alt="Static Badge" src="https://img.shields.io/badge/docker-red"></a>&emsp;
<a href="https://nginx.org/en/download.html"><img alt="Static Badge" src="https://img.shields.io/badge/nginx-gray"></a>&emsp;
<a href="https://www.vim.org/"><img alt="Static Badge" src="https://img.shields.io/badge/vim-purple"></a>&emsp;
<a href="https://www.postgresql.org/"><img alt="Static Badge" src="https://img.shields.io/badge/postgresql-green"></a>&emsp;
<a href="https://kubernetes.io/"><img alt="Static Badge" src="https://img.shields.io/badge/kubernetes-blue"></a>&emsp;
<a href='javascript:((function(){function a(){for(var a=document.getElementsByClassName("mw_added_css"),b=0;b<a.length;b++)document.body.removeChild(a[b])}function b(){var a=document.createElement("div");a.setAttribute("class","mw-strobe_light"),document.body.appendChild(a),setTimeout(function(){document.body.removeChild(a)},100)}function c(a){return{height:a.offsetHeight,width:a.offsetWidth}}function d(a){var b=c(a);return b.height>10&&b.height<2000&&b.width>10&&b.width<2000}function e(a){for(var b=a,c=0;!!b;)c+=b.offsetTop,b=b.offsetParent;return c}function f(a){var b=e(a);return b>=q&&b<=p+q}function g(a){a.className+=" "+n+" "+"im_first"}function h(a){a.className+=" "+n+" "+o[Math.floor(Math.random()*o.length)]}function j(){for(var a=document.getElementsByClassName(n),b=0;b<a.length;)a[b].className=a[b].className.replace(n,"mw-harlem_shake_slow");n="mw-harlem_shake_slow"}function k(){for(var a=document.getElementsByClassName(n),b=new RegExp("\\b"+n+"\\b"),c=0;c<a.length;)a[c].className=a[c].className.replace(b,"")}var l,m,n="mw-harlem_shake_me",o=["im_drunk","im_baked","im_trippin","im_blown"],p=function(){var a=document.documentElement;if(!!window.innerWidth)return window.innerHeight;return a&&!isNaN(a.clientHeight)?a.clientHeight:0}(),q=function(){return window.pageYOffset?window.pageYOffset:Math.max(document.documentElement.scrollTop,document.body.scrollTop)}(),r=document.getElementsByTagName("*"),s=r.length,t=null;for(l=0;l<s;l++)if(m=r[l],d(m)&&f(m)){t=m;break}if(null===m)return void console.warn("Could not find a node of the right size. Please try a different page.");(function(){var a=document.createElement("link");a.setAttribute("type","text/css"),a.setAttribute("rel","stylesheet"),a.setAttribute("href","./resource/harlem-shake-style.css"),a.setAttribute("class","mw_added_css"),document.body.appendChild(a)})(),function(){var c=document.createElement("audio");c.setAttribute("class","mw_added_css"),c.src="./resource/harlem-shake.mp3",c.loop=!1;var d=!1,e=!1,f=!1;c.addEventListener("timeupdate",function(){var a,l=c.currentTime,m=u,n=m.length;if(.5<=l&&!d&&(d=!0,g(t)),15.5<=l&&!e)for(e=!0,k(),b(),a=0;a<n;a++)h(m[a]);28.4<=c.currentTime&&!f&&(f=!0,j())},!0),c.addEventListener("ended",function(){k(),a()},!0),c.innerHTML="<p>If you are reading this, it is because your browser does not support the audio element. We recommend that you get a new browser.</p>",document.body.appendChild(c),c.play()}();var u=[];for(l=0;l<s;l++)m=r[l],d(m)&&u.push(m)})())()' target="_self"><img alt="Static Badge" src="https://img.shields.io/badge/high一下-yellow"></a>&emsp;



## Linux
- [1.Linux服务器硬件基础和操作系统的发展](./LinuxBasics/1.Linux服务器硬件基础和操作系统的发展.md)
- [2.VMWare安装Linux](./LinuxBasics/2.VMWare安装Linux.md)
- [3.Linux基础入门和帮助](./LinuxBasics/3.Linux基础入门和帮助.md)
- [4.文件管理和IO重定向](./LinuxBasics/4.文件管理和IO重定向.md)
- [5.用户-组和权限](./LinuxBasics/5.用户-组和权限.md)
- [6.vim](./LinuxBasics/6.vim.md)
- [7.正则表达式](./LinuxBasics/7.正则表达式.md)
- [8.文本三剑客-grep](./LinuxBasics/8.grep.md)
- [9.文本三剑客-sed](./LinuxBasics/9.sed.md)
- [10.文本三剑客-awk](./LinuxBasics/10.awk.md)
- [11.文件查找和打包压缩](./LinuxBasics/11.文件查找和打包压缩.md)
- [12.shell脚本编程](./LinuxBasics/12.shell脚本编程.md)
- [13.磁盘存储和文件系统](./LinuxBasics/13.磁盘存储和文件系统.md)
- [14.软件管理](./LinuxBasics/14.软件管理.md)
- [15.网络基础](./LinuxBasics/15.网络基础.md)
- [16.Rocky和Ubuntu网络配置](./LinuxBasics/16.Rocky和Ubuntu网络配置.md)
- [17.进程和计划任务](./LinuxBasics/17.进程和计划任务.md)
- [18.系统启动和内核管理](./LinuxBasics/18.系统启动和内核管理.md)
- [19.加密和安全](./LinuxBasics/19.加密和安全.md)
- [20.加密和安全2](./LinuxBasics/20.加密和安全2.md)
- [21.时间同步服务](./LinuxBasics/21.时间同步服务.md)
- [22.DNS服务](./LinuxBasics/22.DNS.md)
- [23.Linux防火墙](./LinuxBasics/23.Linux防火墙.md)

### Linux练习题 
- [1.冯诺依曼体系中计算机有哪些组件](./Interview/冯诺依曼体系中计算机有哪些组件.md)
- [2.Linux哲学思想(法则,原则)是什么?](./Interview/Linux哲学思想是什么.md)
- [3.提示空间满 No space left on device，但 df 可以看到空间很多，为什么](./Interview/提示空间满Nospaceleftondevice但df可以看到空间很多,为什么.md)
- [4.提示空间快满,使用rm删除了很大的无用文件后,df仍然看到空间不足,为什么?如何解决?](./Interview/提示空间快满,使用rm删除了很大的无用文件后,df仍然看到空间不足,为什么如何解决.md)
- [5.文本和文件处理相关习题](./Interview/TextAndFileExercise.md)
- [6.如何在家目录下默认有xxxx文件](./Interview/如何在家目录下默认有xxxx文件.md)
- [7. 文件权限面试题](./Interview/文件权限面试题.md)
- [8.软连接和硬链接区别](./Interview/软连接和硬链接区别.md)
- [9.linux文件类型分别是什么](./Interview/Linux文件类型.md)
- [10.用户和文件权限练习](./Interview/用户和文件权限练习.md)
- [11.shell脚本练习题](./Interview/shell脚本练习题.md)
- [12.利用分区策略相同的另一台主机的分区表来还原和恢复当前主机破环的分区表](./Interview/利用分区策略相同的另一台主机的分区表来还原和恢复当前主机破环的分区表.md)
- [13.文件系统面试题和练习题](./Interview/文件系统面试题.md)
- [14.软件管理练习题](./Interview/软件管理练习题.md)
- [15.网络基础](./Interview/网路基础.md)
- [16.Rocky和Ubuntu网络配置](./Interview/Rocky和Ubuntu网络配置.md)
- [17.进程和计划任务](./Interview/进程和计划任务.md)
- [18.系统启动和内核管理](./Interview/系统启动和内核管理.md)
- [19.加密和安全](./Interview/加密和安全.md)
- [20.DNS服务](./Interview/DNS.md)
- [21.Linux防火墙](./Interview/Linux防火墙.md)

### Linux 脚本
- [RockyLinux和Ubuntu初始化脚本](./scripts/system-reset/system_reset.sh)
- [nginx源码编译安装脚本](./scripts/nginx-install/nginx_install.sh)
- [配置ntp服务器](./scripts/config-ntp-server/config-ntp-server.sh)
- [配置yum服务器](./scripts/config-yum-server/config-yum-server.sh)
- [配置yum服务器](./scripts/config-yum-server/rsync-local-repo.sh)
- [批量分发ssh-key](./scripts/ssh-key-copy/one2more-ssh-key-copy.sh)
- [互相批量分发ssh-key](./scripts/ssh-key-copy/more2more-ssh-key-copy.sh)
- [DNS服务器](./scripts/dns-server/dns-server.sh)


## MySQL
- [1.MySQL安装和基本使用](./MySQL/MySQL/1.MySQL安装和基本使用.md)
- [2.SQL语言](./MySQL/MySQL/2.SQL语言.md)
- [3.MySQL基本管理](./MySQL/MySQL/3.MySQL基本管理.md)
- [4.MySQL性能优化和日志管理](./MySQL/MySQL/4.MySQL性能优化和日志管理.md)
- [5.MySQL备份还原和主从复制集群](./MySQL/MySQL/5.MySQL备份还原和主从复制集群.md)
- [6.MySQL读写分离和高可用集群](./MySQL/MySQL/6.MySQL读写分离和高可用集群.md)


### MySQL练习题
- [2.SQL语言](./MySQL/Exercises/2.sql语言.md)
- [3.MySQL基本管理](./MySQL/Exercises/3.MySQL基本管理.md)


### MySQL相关脚本
- [mysql通用二进制包安装](./MySQL/Scripts/binary_mysql_install.sh)
- [mysql多实例通用二进制包安装](./MySQL/Scripts/muti-install/multi_binary_mysql_install.sh)
- [mysql主从配置](./MySQL/Scripts/config-mysql-master-slave/config_mysql_master_slave.sh)
- [mysql-MyCat配置](./MySQL/Scripts/config_mycat/config_mycat.sh)
- [mysql-MHA配置](./MySQL/Scripts/config-mha-master-slave/config_mha.sh)





## PostgreSQL
- [1.PostgreSQL安装和基本使用](./PostgreSQL/PostgreSQL/1.PostgreSQL安装和基本使用.md)
- [2.PostgreSQL备份和恢复](./PostgreSQL/PostgreSQL/2.PostgreSQL备份和恢复.md)



### PostgreSQL脚本

- [1.源码安装postgresql](./PostgreSQL/scripts/install_postgresql.sh)


## OpenVPN
- [1.openvpn安装和配置](./OpenVPN/1.openvpn安装和配置.md)

### OpenVPN 脚本

- [1.openVPN安装](./OpenVPN/install_config_openvpn.sh)

## 日志服务管理

- [1.日志服务管理](./log-service/1.日志服务管理.md)

## 网络文件共享和同步

- [1.网络文件共享服务和数据实时同步](./nfs-rsync/1.网络文件共享服务和数据实时同步.md)

## 企业级调度器LVS

- [1.企业级调度器lvs](./lvs/1.企业级调度器lvs.md)


## NGINX

- [1.web服务相关概念](./nginx/1.web服务相关概念.md)
- [2.web相关工具](./nginx/2.web相关工具.md)
- [3.nginx架构和安装](./nginx/3.nginx架构和安装.md)
- [4.nginx的核心模块](./nginx/4.nginx的核心模块.md)
- [5.nginx的常见模块](./nginx/5.nginx的常见模块.md)
  - [5.1.nginx的变量](./nginx/5.1.nginx的变量.md)
  - [5.2.nginx自定义访问日志](./nginx/5.2.nginx自定义访问日志.md)
  - [5.3.nginx的https-rewrite-防盗链](./nginx/5.3.nginx的https-rewrite-防盗链.md)
- [6.nginx的第三方模块](./nginx/6.nginx的第三方模块.md)
- [7.nginx的反向代理](./nginx/7.nginx的反向代理.md)

#### nginx脚本

- [1.nginx编译安装脚本](./nginx/scripts/install_nginx.sh)

#### nginx 练习题

- [nginx 练习题](./nginx/nginx_exercise.md)







