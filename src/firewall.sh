#!/bin/bash
set -euo pipefail

echo "[+] $(date) : Configuration stricte de firewalld"

# Activer firewalld si non actif
systemctl enable --now firewalld

# Définir zone par défaut sur "public"
firewall-cmd --set-default-zone=public

# Supprimer toutes les règles existantes dans la zone public
echo "[+] Réinitialisation de la zone public"
firewall-cmd --permanent --zone=public --remove-service=ssh || true
firewall-cmd --permanent --zone=public --remove-service=http || true
firewall-cmd --permanent --zone=public --remove-service=https || true
firewall-cmd --permanent --zone=public --remove-port=22/tcp || true
firewall-cmd --permanent --zone=public --remove-port=443/tcp || true
firewall-cmd --permanent --zone=public --remove-service=dhcpv6-client || true

# Tout bloquer par défaut (zone "public" bloque tout sauf règles ajoutées)
echo "[+] Activation des ports autorisés"
firewall-cmd --permanent --zone=public --add-port=22/tcp
firewall-cmd --permanent --zone=public --add-port=443/tcp

# Reload configuration
firewall-cmd --reload

# Affichage des règles effectives
echo "[+] Règles finales actives :"
firewall-cmd --zone=public --list-all

echo "[+] $(date) : Firewalld verrouillé sauf ports 22 et 443"