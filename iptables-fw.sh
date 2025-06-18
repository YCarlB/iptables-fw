#!/bin/bash

# 用法提示
usage() {
    echo "用法: $0 <本地端口> <目标IP> <目标端口>"
    echo "例如: $0 10099 156.226.175.103 443"
    exit 1
}

# 参数检查
if [ "$#" -ne 3 ]; then
    usage
fi

LOCAL_PORT="$1"
REMOTE_IP="$2"
REMOTE_PORT="$3"

echo "[*] 安装 netfilter-persistent（如果尚未安装）..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y iptables-persistent netfilter-persistent

echo "[*] 启用 IP 转发..."
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

echo "[*] 设置 iptables 规则，将本地 ${LOCAL_PORT} 转发到 ${REMOTE_IP}:${REMOTE_PORT}..."
iptables -t nat -A PREROUTING -p tcp --dport ${LOCAL_PORT} -j DNAT --to-destination ${REMOTE_IP}:${REMOTE_PORT}
iptables -t nat -A POSTROUTING -p tcp -d ${REMOTE_IP} --dport ${REMOTE_PORT} -j MASQUERADE

echo "[*] 保存 iptables 规则..."
netfilter-persistent save

echo "[+] 完成：所有进入本机 TCP ${LOCAL_PORT} 的连接将被转发到 ${REMOTE_IP}:${REMOTE_PORT}"