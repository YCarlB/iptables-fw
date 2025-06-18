# iptables-fw

A simple and reusable shell script that sets up **TCP/UDP port forwarding** on **Debian/Ubuntu** using `iptables`, with automatic installation of `netfilter-persistent` to persist rules after reboot.

---

## ✨ Features

- ✅ Forward a local port to any external IP:port
- ✅ Supports **TCP**, **UDP**, or **both** (default)
- ✅ Automatically enables IP forwarding
- ✅ Automatically installs `iptables-persistent` & `netfilter-persistent`
- ✅ Saves rules permanently
- ✅ Simple one-command setup

---

## 📦 Requirements

- Debian or Ubuntu-based system
- Root privileges

---

## 📄 Usage

### 1. Clone this repository

```bash
git clone https://github.com/yourname/iptables-port-forwarder.git
cd iptables-port-forwarder
```

### 2. Make the script executable

```bash
chmod +x setup-port-forwarding.sh
```

### 3. Run the script

```bash
sudo ./setup-port-forwarding.sh <LOCAL_PORT> <REMOTE_IP> <REMOTE_PORT> [PROTOCOL]
```

- `<LOCAL_PORT>`: The local port to listen on
- `<REMOTE_IP>`: The IP address to forward to
- `<REMOTE_PORT>`: The destination port
- `[PROTOCOL]`: (optional) `tcp`, `udp`, or `both` (default is `both`)

---

### ✅ Examples

#### Forward TCP + UDP (default)

```bash
sudo ./setup-port-forwarding.sh 10099 8.8.8.8 53
```

#### Forward only TCP

```bash
sudo ./setup-port-forwarding.sh 10099 8.8.8.8 53 tcp
```

#### Forward only UDP

```bash
sudo ./setup-port-forwarding.sh 10099 8.8.8.8 53 udp
```

---

## 🔄 What It Does

- Enables IP forwarding by modifying `/etc/sysctl.conf`
- Adds `iptables` rules like:

```bash
# Example if protocol is TCP
iptables -t nat -A PREROUTING -p tcp --dport 10099 -j DNAT --to-destination 8.8.8.8:53
iptables -t nat -A POSTROUTING -p tcp -d 8.8.8.8 --dport 53 -j MASQUERADE
```

- Saves rules using `netfilter-persistent`

---

## 🧼 Uninstall / Cleanup

To remove the rules manually:

```bash
iptables -t nat -D PREROUTING -p tcp --dport <LOCAL_PORT> -j DNAT --to-destination <REMOTE_IP>:<REMOTE_PORT>
iptables -t nat -D POSTROUTING -p tcp -d <REMOTE_IP> --dport <REMOTE_PORT> -j MASQUERADE

iptables -t nat -D PREROUTING -p udp --dport <LOCAL_PORT> -j DNAT --to-destination <REMOTE_IP>:<REMOTE_PORT>
iptables -t nat -D POSTROUTING -p udp -d <REMOTE_IP> --dport <REMOTE_PORT> -j MASQUERADE

netfilter-persistent save
```

---

## 📜 License

MIT License
