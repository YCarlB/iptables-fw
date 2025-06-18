# iptables-port-forwarder

A simple and reusable shell script that sets up **port forwarding** on **Debian/Ubuntu** using `iptables`, with automatic installation of `netfilter-persistent` to ensure the rules persist after reboot.

---

## ✨ Features

- ✅ Forward a local TCP port to any external IP and port
- ✅ Automatically enable IP forwarding
- ✅ Automatically install `iptables-persistent` & `netfilter-persistent`
- ✅ Save `iptables` rules permanently
- ✅ Fully parameterized (IP, port configurable)

---

## 📦 Requirements

- Debian / Ubuntu
- Root privileges

---

## 📄 Usage

### 1. Clone this repository

```bash
git clone https://github.com/yourname/iptables-port-forwarder.git
cd iptables-port-forwarder
```