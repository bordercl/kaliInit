#!/usr/bin/env zsh
# setup-cifs-mount.sh (Zsh + non-TTY)
set -euo pipefail

# --- args ---
if [ "$#" -ne 3 ]; then
  echo "Usage: sudo zsh -s -- <IP> <USER> <PASS>"
  exit 1
fi

SMB_IP="$1"
SMB_USER="$2"
SMB_PASS="$3"

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

# --- mount 関数（oscp と htb の2つに使う） ---
mount_share() {
  SHARE_NAME="$1"     # oscp or htb
  LOCAL_DIR="/home/${LOCAL_USER}/${SHARE_NAME}"
  SHARE_PATH="//${SMB_IP}/${SHARE_NAME}"

  echo "=== Setting up mount for ${SHARE_NAME} ==="

  #--- mount directory ---
  if [ ! -d "$LOCAL_DIR" ]; then
    echo "Creating directory: $LOCAL_DIR"
    mkdir -p "$LOCAL_DIR"
  fi
  chown "$LOCAL_USER":"$LOCAL_USER" "$LOCAL_DIR"

  #--- add fstab ---
  FSTAB_LINE="${SHARE_PATH} ${LOCAL_DIR} cifs username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM} 0 0"

  if ! grep -Fq "${SHARE_PATH}" "$FSTAB"; then
    echo "$FSTAB_LINE" >> "$FSTAB"
    echo "Added fstab entry for ${SHARE_PATH}"
  else
    echo "fstab already contains entry for ${SHARE_PATH}, skipping."
  fi

  #--- test mount ---
  MOUNT_OPTS="username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM}"
  echo "Testing mount: ${SHARE_PATH} → ${LOCAL_DIR}"

  if mount -t cifs "${SHARE_PATH}" "${LOCAL_DIR}" -o "${MOUNT_OPTS}"; then
    echo "✅ Mounted ${SHARE_NAME} successfully."
  else
    echo "❌ Failed to mount ${SHARE_NAME}."
  fi

  echo ""
}

# --- backup fstab only once ---
TS=$(date +%Y%m%d%H%M%S)
cp -a "$FSTAB" "${FSTAB}.bak.${TS}"
echo "/etc/fstab backed up to ${FSTAB}.bak.${TS}"

# --- mount both shares ---
mount_share "oscp"
mount_share "htb"

echo "All done."