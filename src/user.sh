#!/bin/bash
set -euo pipefail

echo "[+] $(date) : Création de l'utilisateur alchemist"

USER="alchemist"
SRC_USER="rocky"

# Vérifier si l'utilisateur existe déjà
if id "$USER" &>/dev/null; then
    echo "[!] L'utilisateur '$USER' existe déjà, étape ignorée."
    exit 0
fi

# Création de l'utilisateur
useradd -m -s /bin/bash "$USER"
usermod -aG wheel "$USER"

# Copie de la clé publique depuis rocky
mkdir -p /home/$USER/.ssh
cp /home/$SRC_USER/.ssh/authorized_keys /home/$USER/.ssh/authorized_keys
chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER/.ssh

# Ajout sudo sans mot de passe (optionnel, comment out si besoin)
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER
chmod 440 /etc/sudoers.d/90-$USER

echo "[+] $(date) : Utilisateur '$USER' prêt avec accès SSH et sudo"