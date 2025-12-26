#!/usr/bin/env zsh

# --------------------------------------------------
# enable_services.zsh
# Enable SSH & Apache services and configure SSH
# --------------------------------------------------

# Root check
if [[ $EUID -ne 0 ]]; then
  echo "[-] This script must be run as root"
  echo "    Please run: sudo $0"
  exit 1
fi

echo "[+] Running as root"

# --------------------------------------------------
# Package installation (commented out by design)
# --------------------------------------------------
# apt update
# apt install -y openssh-server apache2

# --------------------------------------------------
# Backup sshd_config before editing
# --------------------------------------------------
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_CONFIG="/etc/ssh/sshd_config.orig"

echo "[+] Checking sshd_config backup"
if [[ ! -f $BACKUP_CONFIG ]]; then
  echo "[+] Backing up sshd_config to sshd_config.orig"
  cp "$SSHD_CONFIG" "$BACKUP_CONFIG"
else
  echo "[+] Backup already exists"
fi

# --------------------------------------------------
# Enable password authentication
# --------------------------------------------------
echo "[+] Enabling SSH password authentication"

sed -i \
  -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' \
  "$SSHD_CONFIG"

# --------------------------------------------------
# Enable and start services
# --------------------------------------------------
echo "[+] Enabling and starting SSH service"
systemctl enable ssh
systemctl restart ssh

echo "[+] Enabling and starting Apache service"
systemctl enable apache2
systemctl restart apache2

echo "[+] Done"

# --------------------------------------------------
# Check enable status
# --------------------------------------------------
echo "[+] Checking enable status"

echo -n "ssh: "
systemctl is-enabled ssh

echo -n "apache2: "
systemctl is-enabled apache2
