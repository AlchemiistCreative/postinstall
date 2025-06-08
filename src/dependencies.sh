#!/bin/bash
set -euo pipefail

echo "[+] $(date) : Installation des dépendances et outils de base"

# Mise à jour + EPEL
dnf update -y
dnf install -y epel-release

# Outils standards
dnf install -y \
  vim \
  htop \
  git \
  curl \
  wget \
  net-tools \
  lsof \
  unzip \
  bash-completion \
  bind-utils \
  figlet \
  jq

# Docker (via repo officiel)
echo "[+] $(date) : Installation de Docker CE"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Activer et démarrer Docker
systemctl enable --now docker

# Ajouter alchemist (s'il existe) au groupe docker
if id "alchemist" &>/dev/null; then
  usermod -aG docker alchemist
  echo "[+] Ajout de 'alchemist' au groupe docker"
fi

echo "[+] $(date) : Dépendances installées avec succès"