#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/postinstall.log"
LOCK_FILE="/var/lock/postinstall.lock"
BASE_URL="https://raw.githubusercontent.com/AlchemiistCreative/postinstall/refs/heads/main/src"

exec > >(tee -a "$LOG_FILE") 2>&1

# Vérification du verrou
if [ -f "$LOCK_FILE" ]; then
  echo "=== $(date) : Le script a déjà été exécuté. Abandon. ==="
  exit 1
fi

# Création du verrou
touch "$LOCK_FILE"
echo "=== $(date) : Lancement de l'installation complète ==="

# Étapes
curl -fsSL "$BASE_URL/user.sh" | bash
curl -fsSL "$BASE_URL/profile-stackx.sh" -o /etc/profile.d/alchemist.sh && chmod +x /etc/profile.d/alchemist.sh
curl -fsSL "$BASE_URL/.bashrc" -o /home/alchemist/.bashrc && chown alchemist:alchemist /home/alchemist/.bashrc
curl -fsSL "$BASE_URL/dependencies.sh" | bash
curl -fsSL "$BASE_URL/fail2ban.sh" | bash
curl -fsSL "$BASE_URL/firewall.sh" | bash

echo "=== $(date) : Installation terminée ==="