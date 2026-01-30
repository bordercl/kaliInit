#!/usr/bin/env zsh
set -e

# sudo で実行していないかチェック
if [[ "$EUID" -eq 0 ]]; then
  echo "[!] このスクリプトは sudo なしで実行してください。"
  echo "    sudo で実行すると /root 配下にマウントされてしまいます。"
  exit 1
fi

echo "[*] VMware Shared Folder setup (bind mount, persistent)"
echo
echo "=== Host OS memo ==="
echo "VMware Settings → Options → Shared Folders"
echo "- Enable: Always enabled"
echo "- Folder names: oscp, htb"
echo "===================="
echo

# 必要パッケージ（※現在の環境では挙動に影響なし）
# 将来的に open-vm-tools が未導入な環境で使う可能性があるため残す
# sudo apt update
# sudo apt install -y open-vm-tools fuse

# マウントポイント作成
mkdir -p "$HOME/oscp" "$HOME/htb"

# fstab エントリ（bind + nofail）
OSCP_ENTRY="/mnt/hgfs/oscp  $HOME/oscp  none  bind,nofail  0  0"
HTB_ENTRY="/mnt/hgfs/htb   $HOME/htb   none  bind,nofail  0  0"

# fstab 追記（重複防止）
if ! grep -Fxq "$OSCP_ENTRY" /etc/fstab; then
  echo "[*] Adding oscp bind mount to /etc/fstab"
  echo "$OSCP_ENTRY" | sudo tee -a /etc/fstab
fi

if ! grep -Fxq "$HTB_ENTRY" /etc/fstab; then
  echo "[*] Adding htb bind mount to /etc/fstab"
  echo "$HTB_ENTRY" | sudo tee -a /etc/fstab
fi

# fstab 反映
echo "[*] Mounting via fstab"
sudo mount -a

echo
echo "[+] Shared folders ready (persistent):"
echo " - /mnt/hgfs/oscp -> $HOME/oscp"
echo " - /mnt/hgfs/htb  -> $HOME/htb"