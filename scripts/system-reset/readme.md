初始化 最小化安装的rocky8和ubuntu20.4

```bash
cd ./system-reset

bash system_reset.sh

在 system_reset.sh 文件开头，可以自定义配置

LOCAL_REPO=1   #对于rocky yum仓库配置 1：启用本地仓库 0：启用远程阿里云的yum仓库
LOCAL_REPO_IP=10.0.0.4  #本地yum仓库的主机ip地址
HOST_IP="10.0.0.3"   #配置本主机的ip地址
```