#!/bin/bash

# 用法说明
usage() {
    echo "用法: $0 <本地端口> <目标IP> <目标端口> [协议]"
    echo "示例: $0 10099 8.8.8.8 53 tcp"
    echo "协议: tcp | udp | both （可选，默认 both）"
    exit 1
}

# 参数解析
if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    usage
fi

LOCAL_PORT="$1"
REMOTE_IP="$2"
REMOTE_PORT="$3"
PROTOCOL="${4:-both}"  # 默认 both

# 协议检查
if [[ "$PROTOCOL" != "tcp" && "$PROTOCOL" != "udp" && "$PROTOCOL" != "both" ]]; then
    echo "错误：协议必须为 tcp、udp 或 both"
    usage
fi

echo "[*] 安装 netfilter-persistent（如果尚未安装）..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y iptables-persistent netfilter-persistent

echo "[*] 启用 IP 转发..."
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i '/^net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

apply_rule() {
    local proto=$1
    echo "[*] 设置 iptables 转发规则：$proto $LOCAL_PORT -> $REMOTE_IP:$REMOTE_PORT"
    iptables -t nat -A PREROUTING -p $proto --dport $LOCAL_PORT -j DNAT --to-destination $REMOTE_IP:$REMOTE_PORT
    iptables -t nat -A POSTROUTING -p $proto -d $REMOTE_IP --dport $REMOTE_PORT -j MASQUERADE
}

# 根据协议设置规则
case "$PROTOCOL" in
    tcp)  apply_rule tcp ;;
    udp)  apply_rule udp ;;
    both) apply_rule tcp; apply_rule udp ;;
esac

echo "[*] 保存 iptables 规则..."
netfilter-persistent save

echo "[+] 完成：${PROTOCOL^^} 流量已从本地 ${LOCAL_PORT} 转发至 ${REMOTE_IP}:${REMOTE_PORT}"