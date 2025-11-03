#!/usr/bin/env zsh
# setup-vmshare-mount.sh  (zsh, non-TTY friendly)

set -euo pipefail

# --- args ---
if [ "$#" -ne 3 ]; then
  echo "Usage: sudo zsh -s -- <IP> <USERNAME> <PASSWORD>"
  exit 1
fi

IP="$1"
USERNAME="$2"
PASSWORD="$3"

MOUNT_POINT="/vmshare"
SHARE="//${IP}/vmshare"
FSTAB="/etc/fstab"

# --- root check ---
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# --- ensure cifs-utils ---
if ! command -v mount.cifs >/dev/null 2>&1; then
  echo "Installing cifs-utils..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y && apt-get install -y cifs-utils
  else
    echo "Please install cifs-utils manually."
    exit 1
  fi
fi

# --- determine local user safely ---
if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
  LOCAL_USER="$SUDO_USER"
else
  LOCAL_USER=$(who | awk 'NR==1{print $1}' || echo "root")
fi
[[ -n "$LOCAL_USER" ]] || LOCAL_USER="root"

UID_NUM=$(id -u "$LOCAL_USER" 2>/dev/null || echo 0)
GID_NUM=$(id -g "$LOCAL_USER" 2>/dev/null || echo 0)

# --- mount point setup ---
mkdir -p "$MOUNT_POINT"
chown "$LOCAL_USER":"$LOCAL_USER" "$MOUNT_POINT"

# --- backup fstab ---
TS=$(date +%Y%m%d%H%M%S)
cp -a "$FSTAB" "${FSTAB}.bak.${TS}"
echo "/etc/fstab backed up to ${FSTAB}.bak.${TS}"

# --- fstab entry ---
FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM} 0 0"
#FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM},noauto,x-systemd.automount 0 0"

if ! grep -Fq "${SHARE}" "$FSTAB"; then
  echo "$FSTAB_LINE" >> "$FSTAB"
  echo "Added fstab entry for ${SHARE}"
else
  echo "fstab already contains an entry for ${SHARE}; skipping append."
fi

# --- test mount ---
MOUNT_OPTS="username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM}"
echo "Testing mount: mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"
if mount -t cifs "${SHARE}" "${MOUNT_POINT}" -o "${MOUNT_OPTS}"; then
  echo "✅ Mounted ${MOUNT_POINT} successfully."
else
  echo "❌ Mount failed. Try manually:"
  echo "  sudo mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"
fi

echo "Done."
