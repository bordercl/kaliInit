#!/usr/bin/env zsh
# setup-vmshare-mount.sh  (zsh, non-TTY friendly)
# Usage:
#   sudo zsh -s -- <IP> <USERNAME> <PASSWORD>
# Example:
#   sudo curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-vmshare-mount.sh | sudo zsh -s -- 10.0.0.9 ryosuke veriserve

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

# check root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# ensure cifs-utils (mount.cifs) exists
if ! command -v mount.cifs >/dev/null 2>&1; then
  echo "cifs-utils not found — installing..."
  # Debian/Ubuntu style install
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y cifs-utils
  else
    echo "Please install cifs-utils manually for your distro and re-run."
    exit 1
  fi
fi

# determine owner (prefer sudo invoker)
if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  LOCAL_USER="$SUDO_USER"
else
  LOCAL_USER=$(logname 2>/dev/null || echo "root")
fi

UID_NUM=$(id -u "$LOCAL_USER")
GID_NUM=$(id -g "$LOCAL_USER")

# create mount point
mkdir -p "$MOUNT_POINT"
chown "$LOCAL_USER":"$LOCAL_USER" "$MOUNT_POINT"

# backup fstab
TS=$(date +%Y%m%d%H%M%S)
cp -a "$FSTAB" "${FSTAB}.bak.${TS}"
echo "/etc/fstab backed up to ${FSTAB}.bak.${TS}"

# prepare fstab entry (direct username/password written)
# default options: vers=3.0, iocharset=utf8, uid/gid from local user, noauto + automount
#FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUMi},gid=${GID_NUM},noauto,x-systemd.automount 0 0"
FSTAB_LINE="${SHARE} ${MOUNT_POINT} cifs username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUMi},gid=${GID_NUM} 0 0"

# append if not present
if ! grep -Fq "${SHARE}" "$FSTAB"; then
  echo "$FSTAB_LINE" >> "$FSTAB"
  echo "Added fstab entry for ${SHARE}"
else
  echo "fstab already contains an entry for ${SHARE}; skipping append."
fi

# try immediate mount (use explicit mount.cifs with same options)
MOUNT_OPTS="username=${USERNAME},password=${PASSWORD},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM}"
echo "Attempting immediate mount: mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"
if mount -t cifs "${SHARE}" "${MOUNT_POINT}" -o "${MOUNT_OPTS}"; then
  echo "Mounted ${MOUNT_POINT} successfully."
  ls -la "${MOUNT_POINT}" || true
else
  echo "Immediate mount failed. You can try manually:"
  echo "  sudo mount -t cifs ${SHARE} ${MOUNT_POINT} -o ${MOUNT_OPTS}"
  echo "Check dmesg / journalctl for CIFS-related messages."
fi

echo "Done. Note: /etc/fstab contains credentials in plain text. Consider using a credentials file for better security."
