# TLSAN
> The Linux System Administration Notes

<img alt="Static Badge" src="https://img.shields.io/badge/Linux-Shell-blue">&emsp;
<img alt="Static Badge" src="https://img.shields.io/badge/License-MPL--2.0-yellow">&emsp;
<a href="https://hub.docker.com/"  target="_blank"><img alt="Static Badge" src="https://img.shields.io/badge/docker-red"></a>&emsp;
<a href="https://nginx.org/en/download.html"><img alt="Static Badge" src="https://img.shields.io/badge/nginx-gray"></a>&emsp;
<a href="https://www.vim.org/"><img alt="Static Badge" src="https://img.shields.io/badge/vim-purple"></a>&emsp;
<a href='javascript:(function(){function h(){var e=document.createElement("link");e.setAttribute("type","text/css");e.setAttribute("rel","stylesheet");e.setAttribute("href",l);e.setAttribute("class",c);document.body.appendChild(e)}function p(){var e=document.getElementsByClassName(c);for(var t=0;t<e.length;t++){document.body.removeChild(e[t])}}function d(){var e=document.createElement("div");e.setAttribute("class",f);document.body.appendChild(e);setTimeout(function(){document.body.removeChild(e)},100)}function v(e){return{height:e.offsetHeight,width:e.offsetWidth}}function m(i){var s=v(i);return s.height>e&&s.height<n&&s.width>t&&s.width<r}function g(e){var t=e;var n=0;while(!!t){n+=t.offsetTop;t=t.offsetParent}return n}function y(){var e=document.documentElement;if(!!window.innerWidth){return window.innerHeight}else if(e&&!isNaN(e.clientHeight)){return e.clientHeight}return 0}function b(){if(window.pageYOffset){return window.pageYOffset}return Math.max(document.documentElement.scrollTop,document.body.scrollTop)}function S(e){var t=g(e);return t>=E&&t<=w+E}function x(){var e=document.createElement("audio");e.setAttribute("class",c);e.src=i;e.loop=false;var t=false,n=false,r=false;e.addEventListener("timeupdate",function(){var i=e.currentTime,s=D,o=s.length,u;if(i>=.5&&!t){t=true;T(_)}if(i>=15.5&&!n){n=true;k();d();for(u=0;u<o;u++){N(s[u])}}if(e.currentTime>=28.4&&!r){r=true;C()}},true);e.addEventListener("ended",function(){k();p()},true);e.innerHTML="<p>If you are reading this, it is because your browser does not support the audio element. We recommend that you get a new browser.</p>";document.body.appendChild(e);e.play()}function T(e){e.className+=" "+s+" "+u}function N(e){e.className+=" "+s+" "+a[Math.floor(Math.random()*a.length)]}function C(){var e=document.getElementsByClassName(s);for(var t=0;t<e.length;){e[t].className=e[t].className.replace(s,o)}s=o}function k(){var e=document.getElementsByClassName(s);var t=new RegExp("\\b"+s+"\\b");for(var n=0;n<e.length;){e[n].className=e[n].className.replace(t,"")}}var e=30;var t=30;var n=350;var r=350;var i="./resource/harlem-shake.mp3";var s="mw-harlem_shake_me";var o="mw-harlem_shake_slow";var u="im_first";var a=["im_drunk","im_baked","im_trippin","im_blown"];var f="mw-strobe_light";var l="./resource/harlem-shake-style.css";var c="mw_added_css";var w=y();var E=b();var L=document.getElementsByTagName("*"),A=L.length,O,M;var _=null;for(O=0;O<A;O++){M=L[O];if(m(M)){if(S(M)){_=M;break}}}if(M===null){console.warn("Could not find a node of the right size. Please try a different page.");return}h();x();var D=[];for(O=0;O<A;O++){M=L[O];if(m(M)){D.push(M)}}})()'><img alt="Static Badge" src="https://img.shields.io/badge/high一下-yellow" target="_self"></a>&emsp;



## Linux
###### [1.Linux服务器硬件基础和操作系统的发展](./LinuxBasics/1.Linux服务器硬件基础和操作系统的发展.md)
###### [2.VMWare安装Linux](./LinuxBasics/2.VMWare安装Linux.md)
###### [3.Linux基础入门和帮助](./LinuxBasics/3.Linux基础入门和帮助.md)
###### [4.文件管理和IO重定向](./LinuxBasics/4.文件管理和IO重定向.md)
###### [5.用户-组和权限](./LinuxBasics/5.用户-组和权限.md)
###### [6.vim](./LinuxBasics/6.vim.md)
###### [7.正则表达式](./LinuxBasics/7.正则表达式.md)
###### [8.文本三剑客-grep](./LinuxBasics/8.grep.md)
###### [9.文本三剑客-sed](./LinuxBasics/9.sed.md)
###### [10.文本三剑客-awk](./LinuxBasics/10.awk.md)
###### [11.文件查找和打包压缩](./LinuxBasics/11.文件查找和打包压缩.md)
###### [12.shell脚本编程](./LinuxBasics/12.shell脚本编程.md)
###### [13.磁盘存储和文件系统](./LinuxBasics/13.磁盘存储和文件系统.md)
###### [14.软件管理](./LinuxBasics/14.软件管理.md)
###### [15.网络基础](./LinuxBasics/15.网络基础.md)
###### [16.Rocky和Ubuntu网络配置](./LinuxBasics/16.Rocky和Ubuntu网络配置.md)
###### [17.进程和计划任务](./LinuxBasics/17.进程和计划任务.md)
###### [18.系统启动和内核管理](./LinuxBasics/18.系统启动和内核管理.md)
###### [19.加密和安全](./LinuxBasics/19.加密和安全.md)
###### [20.加密和安全2](./LinuxBasics/20.加密和安全2.md)
###### [21.时间同步服务](./LinuxBasics/21.时间同步服务.md)


## Linux 脚本
###### [RockyLinux和Ubuntu初始化脚本](./scripts/system-reset/system_reset.sh)
###### [nginx源码编译安装脚本](./scripts/nginx-install/nginx_install.sh)
###### [配置ntp服务器](./scripts/config-ntp-server/config-ntp-server.sh)
###### [配置yum服务器](./scripts/config-yum-server/config-yum-server.sh)
###### [配置yum服务器](./scripts/config-yum-server/rsync-local-repo.sh)
###### [批量分发ssh-key](./scripts/ssh-key-copy/one2more-ssh-key-copy.sh)
###### [互相批量分发ssh-key](./scripts/ssh-key-copy/more2more-ssh-key-copy.sh)


## Linux练习题 
###### [1.冯诺依曼体系中计算机有哪些组件](./Interview/冯诺依曼体系中计算机有哪些组件.md)
###### [2.Linux哲学思想(法则,原则)是什么?](./Interview/Linux哲学思想是什么.md)
###### [3.提示空间满 No space left on device，但 df 可以看到空间很多，为什么](./Interview/提示空间满Nospaceleftondevice但df可以看到空间很多,为什么.md)
###### [4.提示空间快满,使用rm删除了很大的无用文件后,df仍然看到空间不足,为什么?如何解决?](./Interview/提示空间快满,使用rm删除了很大的无用文件后,df仍然看到空间不足,为什么如何解决.md)
###### [5.文本和文件处理相关习题](./Interview/TextAndFileExercise.md)
###### [6.如何在家目录下默认有xxxx文件](./Interview/如何在家目录下默认有xxxx文件.md)
###### [7. 文件权限面试题](./Interview/文件权限面试题.md)
###### [8.软连接和硬链接区别](./Interview/软连接和硬链接区别.md)
###### [9.linux文件类型分别是什么](./Interview/Linux文件类型.md)
###### [10.用户和文件权限练习](./Interview/用户和文件权限练习.md)
###### [11.shell脚本练习题](./Interview/shell脚本练习题.md)
###### [12.利用分区策略相同的另一台主机的分区表来还原和恢复当前主机破环的分区表](./Interview/利用分区策略相同的另一台主机的分区表来还原和恢复当前主机破环的分区表.md)
###### [13.文件系统面试题和练习题](./Interview/文件系统面试题.md)
###### [14.软件管理练习题](./Interview/软件管理练习题.md)
###### [15.网络基础](./Interview/网路基础.md)
###### [16.Rocky和Ubuntu网络配置](./Interview/Rocky和Ubuntu网络配置.md)
###### [17.进程和计划任务](./Interview/进程和计划任务.md)
###### [18.系统启动和内核管理](./Interview/系统启动和内核管理.md)
###### [19.加密和安全](./Interview/加密和安全.md)



