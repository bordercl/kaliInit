#!/usr/bin/env zsh
# setup-vmshare-mount.sh (Zsh + non-TTY)
set -euo pipefail

# --- args ---
if [ "$#" -ne 3 ]; then
  echo "Usage: sudo zsh -s -- <IP> <USER> <PASS>"
  exit 1
fi

SMB_IP="$1"
SMB_USER="$2"
SMB_PASS="$3"

MOUNT_POINT="/vmshare"
SHARE="//${SMB_IP}/vmshare"
FSTAB="/etc/fstab"

# --- root check ---
if [ "$EUID" -ne 0 ]; then
  echo "このスクリプトは root 権限で実行してください。"
  exit 1
fi

# --- cifs-utils 確認 ---
if ! command -v mount.cifs >/dev/null 2>&1; then
  echo "Installing cifs-utils..."
  apt-get update -y && apt-get install -y cifs-utils
fi

# --- 実行ユーザー判定 ---
if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
  LOCAL_USER="$SUDO_USER"
else
  LOCAL_USER=$(who | awk 'NR==1{print $1}' || echo "root")
fi
[[ -n "$LOCAL_USER" ]] || LOCAL_USER="root"

UID_NUM=$(id -u "$LOCAL_USER" 2>/dev/null || echo 0)
GID_NUM=$(id -g "$LOCAL_USER" 2>/dev/null || echo 0)

# --- mount point 作成 ---
mkdir -p "$MOUNT_POINT"
chown "$LOCAL_USER":"$LOCAL_USER" "$MOUNT_POINT"

# --- fstab バックアップ ---
TS=$(date +%Y%m%d%H%M%S)
cp -a "$FSTAB" "${FSTAB}.bak.${TS}"
echo "/etc/fstab backed up to ${FSTAB}.bak.${TS}"

# --- fstab entry ---
FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM} 0 0"
#FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM},noauto,x-systemd.automount 0 0"

if ! grep -Fq "${SHARE}" "$FSTAB"; then
  echo "$FSTAB_LINE" >> "$FSTAB"
  echo "Added fstab entry for ${SHARE}"
else
  echo "fstab already contains an entry for ${SHARE}; skipping append."
fi

# --- test mount ---
MOUNT_OPTS="username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM}"
echo "Testing mount: mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"

if mount -t cifs "${SHARE}" "${MOUNT_POINT}" -o "${MOUNT_OPTS}"; then
  echo "✅ Mounted ${MOUNT_POINT} successfully."
else
  echo "❌ Mount failed. Try manually:"
  echo "  sudo mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"
fi

echo "Done."
