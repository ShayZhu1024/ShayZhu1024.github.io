# nginx 源码编译安装脚本

```bash
cd  ./nginx-install
bash nginx_install.sh

自定义配置，修改./config.sh


DEST=/app/nginx     #nginx的安装位置
VERSION=1.20.2      #nginx的版本
SRC=/usr/local/src  #nginx的压缩包存放位置
ARG=--with-http_ssl_module  #./configure 的配置参数， 多个参数 需要用"" 包裹




对应需要的依赖包写在load_dependencies.sh 文件中
```