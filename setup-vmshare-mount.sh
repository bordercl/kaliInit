#!/usr/bin/env zsh
# setup_vmshare_mount.sh (for zsh)
set -euo pipefail

# rootチェック
if [ "$EUID" -ne 0 ]; then
  echo "このスクリプトは root 権限で実行してください。"
  exit 1
fi

# 対話的入力
echo -n "SMBサーバのIPアドレスを入力してください: "
read SMB_IP

echo -n "ユーザー名を入力してください: "
read SMB_USER

echo -n "パスワードを入力してください（表示されません）: "
stty -echo
read SMB_PASS
stty echo
echo

# 固定値
SMB_SHARE="vmshare"
MOUNT_POINT="/vmshare"

# 所有者判定
if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
  LOCAL_USER="$SUDO_USER"
else
  LOCAL_USER=$(logname 2>/dev/null || echo "root")
fi

UID_NUM=$(id -u "$LOCAL_USER")
GID_NUM=$(id -g "$LOCAL_USER")

echo
echo "設定内容:"
echo "  SMBサーバ : //$SMB_IP/$SMB_SHARE"
echo "  マウント先 : $MOUNT_POINT"
echo "  ローカルユーザー : $LOCAL_USER (uid=$UID_NUM, gid=$GID_NUM)"
echo
echo -n "続けますか？(y/N): "
read CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
  echo "キャンセルしました。"
  exit 0
fi

# マウントポイント作成
mkdir -p "$MOUNT_POINT"
chown "$LOCAL_USER":"$LOCAL_USER" "$MOUNT_POINT"

# fstab バックアップ
FSTAB="/etc/fstab"
BACKUP="${FSTAB}.bak.$(date +%Y%m%d%H%M%S)"
cp -a "$FSTAB" "$BACKUP"
echo "/etc/fstab をバックアップしました → $BACKUP"

# fstab 行作成
FSTAB_LINE="//${SMB_IP}/${SMB_SHARE} ${MOUNT_POINT} cifs username=${SMB_USER},password=${SMB_PASS},vers=3.0,iocharset=utf8,uid=${UID_NUM},gid=${GID_NUM},noauto,x-systemd.automount 0 0"

# 重複チェック
if grep -Fq "${MOUNT_POINT}" "$FSTAB"; then
  echo "注意: $MOUNT_POINT のエントリがすでに存在します。スキップします。"
else
  echo "$FSTAB_LINE" >> "$FSTAB"
  echo "/etc/fstab にエントリを追加しました。"
fi

# テストマウント
echo "マウントをテスト中..."
if mount -a; then
  echo "✅ マウント成功: $MOUNT_POINT"
  ls -l "$MOUNT_POINT"
else
  echo "❌ mount -a に失敗しました。手動で以下を試してください："
  echo "sudo mount -t cifs //$SMB_IP/$SMB_SHARE $MOUNT_POINT -o username=$SMB_USER,password=$SMB_PASS,vers=3.0,iocharset=utf8,uid=$UID_NUM,gid=$GID_NUM"
fi

echo
echo "完了しました。再起動後も systemd automount により遅延マウントされます。"
