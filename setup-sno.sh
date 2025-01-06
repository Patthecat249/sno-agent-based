#!/bin/bash

set -e

# Repository-URL und Zielverzeichnis
REPO_URL="https://github.com/Patthecat249/sno-agent-based"
REPO_DIR="/workspace/sno-agent-based"

# Aktuelles Repository klonen oder aktualisieren
if [ -d "$REPO_DIR" ]; then
  echo "Repository existiert bereits. Aktualisiere..."
  git -C "$REPO_DIR" pull
else
  echo "Klone Repository..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

# Ins Verzeichnis wechseln
cd "$REPO_DIR"

# Ansible-Playbook ausführen
ansible-playbook install-sno.yaml --vault-password-file $MYPATH/password.txt -e "cluster_name=sno3" -e "ip_address=10.0.249.55" -e "mac_address=00:50:56:9c:49:8b"
ansible-playbook -i inventory.ini install-sno.yaml --vault-password-file $MYPATH/password.txt -e "cluster_name=sno3" -e "ip_address=10.0.249.55" -e "mac_address=00:50:56:9c:49:8b"
