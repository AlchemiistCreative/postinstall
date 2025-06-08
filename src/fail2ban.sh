#!/bin/bash
set -euo pipefail

echo "[+] $(date) : Installation et configuration de Fail2Ban"

# Installation
dnf install -y fail2ban

# Activation du service
systemctl enable --now fail2ban

# Configuration de base pour SSH
cat <<EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = systemd
maxretry = 5
findtime = 10m
bantime = 1h
EOF

# Redémarrage pour prise en compte
systemctl restart fail2ban

echo "[+] $(date) : Fail2Ban configuré et actif"