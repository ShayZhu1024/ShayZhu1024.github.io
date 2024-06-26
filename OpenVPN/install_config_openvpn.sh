#!/bin/bash

set -u
set -e


PUSH_INNER_NET="192.168.10.0 255.255.255.0"
VPN_NET="10.8.0.0 255.255.255.0"
HOST_IP=10.0.0.3

setup_server()
{

    yum -y install openvpn easy-rsa
    #拷贝easy-rsa的证书颁发的相关模板文件目录到openvpn的配置文件目录下
    cp -r /usr/share/easy-rsa/3/ /etc/openvpn/easy-rsa
    cp /usr/share/doc/easy-rsa/vars.example  /etc/openvpn/easy-rsa/vars
    #ca 证书有效年100年
    sed -ri "s/^#(set_var EASYRSA_CA_EXPIRE).*/\1      36500/" /etc/openvpn/easy-rsa/vars
    #服务器证书默为为825天,可适当加长,比如:3650天
    sed -ri "s/^#(set_var EASYRSA_CERT_EXPIRE).*/\1   3650/" /etc/openvpn/easy-rsa/vars
    cd /etc/openvpn/easy-rsa
    #初始化PKI生成PKI相关目录和文件
    ./easyrsa init-pki
#创建 CA 机构证书环境,生成自签名ca证书
./easyrsa build-ca nopass <<EOF

EOF
#创建服务端证书申请，其中server是文件前缀
./easyrsa gen-req server nopass <<EOF

EOF
#颁发服务端证书
#第一个server表示证书的类型,第二个server表示请求文件名的前缀
./easyrsa sign server server <<EOF
yes
EOF
    # 创建 Diffie-Hellman 密钥
    ./easyrsa  gen-dh
    #将CA和服务器证书相关文件复制到服务器相应的目录
    cp /etc/openvpn/easy-rsa/pki/ca.crt /etc/openvpn/server/
    cp /etc/openvpn/easy-rsa/pki/issued/server.crt  /etc/openvpn/server
    cp /etc/openvpn/easy-rsa/pki/private/server.key /etc/openvpn/server
    cp /etc/openvpn/easy-rsa/pki/dh.pem /etc/openvpn/server
#配置 OpenVPN 服务器并启动服务
#cp /usr/share/doc/openvpn/sample/sample-config-files/server.conf /etc/openvpn/
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto tcp
dev tun
ca  /etc/openvpn/server/ca.crt
cert /etc/openvpn/server/server.crt
key /etc/openvpn/server/server.key  # This file should be kept secret
dh /etc/openvpn/server/dh.pem
server ${VPN_NET}
push "route ${PUSH_INNER_NET}"
keepalive 10 120
cipher AES-256-CBC
compress lz4-v2
push "compress lz4-v2"
max-clients 2048
user openvpn
group openvpn
status       /var/log/openvpn/penvpn-status.log
log-append   /var/log/openvpn/openvpn.log
verb 3
mute 20
EOF

    mkdir -p /var/log/openvpn/
    chown openvpn:openvpn -R /var/log/openvpn/

#红帽8系列需要增加service文件，7版本里面带的有，不需要加
cat > /lib/systemd/system/openvpn@.service <<EOF
[Unit]
Description=OpenVPN Robust And Highly Flexible Tunneling Application On %I
After=network.target

[Service]
Type=notify
PrivateTmp=true
ExecStart=/usr/sbin/openvpn --cd /etc/openvpn/ --config %i.conf

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload 
systemctl enable --now openvpn@server.service

}



setup_client()
{
    cd  /etc/openvpn/easy-rsa/
    read -r -p "客户端名字(字母组合): " NAME
    read -r -p "客户端证书过期时间(单位:天): " CLIENT_EXPIRE

    #准备客户端证书环境
    # 修改客户端证书有效期
    sed -ri "s/^(set_var EASYRSA_CERT_EXPIRE).*/\1   $CLIENT_EXPIRE/" /etc/openvpn/easy-rsa/vars
#创建客户端证书申请
/etc/openvpn/easy-rsa/easyrsa gen-req $NAME  nopass <<EOF

EOF


# 颁发客户端证书
/etc/openvpn/easy-rsa/easyrsa sign client $NAME <<EOF
yes
EOF

#将客户端私钥与证书相关文件复制到服务器相关的目录
mkdir -p /etc/openvpn/client/$NAME/
find /etc/openvpn/easy-rsa/ \( -name "$NAME.crt" -o -name "$NAME.key" -o -name "ca.crt" \)  -exec cp {} /etc/openvpn/client/$NAME/ \;

#准备 OpenVPN 客户端配置文件
cat  > /etc/openvpn/client/$NAME/client.ovpn <<EOF

client
dev tun
proto tcp
remote $HOST_IP  1194
resolv-retry infinite
nobind
#persist-key
#persist-tun
ca ca.crt
cert ${NAME}.crt
key ${NAME}.key
remote-cert-tls server
#tls-auth ta.key 1
cipher AES-256-CBC
verb 3
compress lz4-v2

EOF

mkdir -p ../client-tar/$NAME/
tar zcf  ../client-tar/$NAME/${NAME}.tar.gz   ../client/${NAME}/ 
}

MENU="
配置VPN服务器
产生客户端配置
退出
"
PS3="请选择: "
select item in  $MENU; do 
    case $(tr -d " " <<<"$REPLY") in
        1)
            setup_server
            ;;
        2)
            setup_client
            ;;
        3) 
            exit
            ;;
        *) 
            echo "无对应操作"
            ;;
    esac
done
