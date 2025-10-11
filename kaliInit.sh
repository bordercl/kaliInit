#!/bin/bash
set -e

echo "=== [1/6] Updating package list ==="
sudo apt update

echo "=== [2/6] Installing Japanese language environment ==="
sudo apt install -y task-japanese task-japanese-desktop

echo "=== [3/6] Installing fcitx + Anthy ==="
sudo apt install -y fcitx fcitx-config-gtk fcitx-ui-classic fcitx-anthy anthy fonts-noto-cjk

echo "=== [4/6] Configuring environment variables for IME ==="
RC_FILE="$HOME/.zshrc"
for line in \
  'export GTK_IM_MODULE=fcitx' \
  'export QT_IM_MODULE=fcitx' \
  'export XMODIFIERS=@im=fcitx'; do
  grep -qxF "$line" "$RC_FILE" || echo "$line" >> "$RC_FILE"
done

echo "=== [5/6] Applying environment variables ==="
# shellcheck source=/dev/null
source "$RC_FILE"

echo "=== [6/6] Restarting fcitx ==="
fcitx -r || true

echo ""
echo "✅ セットアップ完了!"
echo ""
echo "==== 必須: fcitx-configtool を起動して以下を設定してください ===="
echo "1. 「入力メソッド」タブを開く"
echo "2. Anthy を追加"
echo "3. 一覧の上位に置くと優先入力になります"
echo ""
echo "「Ctrl + ,」で切り替えできるか確認してください"
echo ""
echo "fcitx-configtool を起動します..."
fcitx-configtool
