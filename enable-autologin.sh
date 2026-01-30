#!/bin/bash
# Enable LightDM autologin only if not already enabled, with verification

CONF="/etc/lightdm/lightdm.conf"
USER_NAME="kali"
BACKUP="/etc/lightdm/lightdm.conf.bak.$(date +%F_%T)"

# rootチェック
if [ "$EUID" -ne 0 ]; then
  echo "[!] Run as root (sudo)"
  exit 1
fi

# すでに有効ならスキップ
if grep -q "^autologin-user=${USER_NAME}$" "$CONF" && \
   grep -q "^autologin-user-timeout=0$" "$CONF"; then
  echo "[=] Autologin already enabled. Skipping."
  echo "[*] Current setting:"
  grep -n "autologin-user" "$CONF"
  exit 0
fi

echo "[*] Backup: $BACKUP"
cp "$CONF" "$BACKUP"

# コメント行を置換
sed -i "s/^#autologin-user=.*/autologin-user=${USER_NAME}/" "$CONF"
sed -i "s/^#autologin-user-timeout=.*/autologin-user-timeout=0/" "$CONF"

echo "[+] Autologin enabled for user: $USER_NAME"
echo "[*] Verification:"
grep -n "autologin-user" "$CONF"

echo "[+] Reboot to apply"
