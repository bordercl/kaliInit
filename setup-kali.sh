#!/usr/bin/env zsh
set -e  # エラー時に即終了

echo "=== [1/4] タイムゾーンを日本（Asia/Tokyo）に設定 ==="
sudo timedatectl set-timezone Asia/Tokyo
echo "→ 現在のタイムゾーン: $(timedatectl | grep 'Time zone')"
echo ""

echo "=== [2/4] 日本語キーボード設定 ==="
# X11のデフォルトキーボードを日本語に変更
echo "→ X11 デフォルトキーボードを日本語 (jp) に設定"
sudo localectl set-x11-keymap jp

# 設定確認
echo "X11 Layout 設定確認:"
localectl status | grep "X11 Layout"
echo ""

# XFCE GUI の Use system default をオフに（可能な限り）
echo "→ XFCE GUI: Use system default をオフにする試み"
xfconf-query -c keyboard-layout -p /DefaultLayout -n -t bool -s false 2>/dev/null || true
xfconf-query -c keyboard-layout -p /Layouts -n -t string -s jp 2>/dev/null || true

echo ""
echo "✅ 日本語キーボード設定完了！"
echo "⚠️ XFCE パネルの 'Keyboard Layouts' プラグインで日本語を追加し、'Use system default' をオフにしてください。"
echo "設定は再ログイン後に反映されます。"
echo ""

echo "=== [3/4] スクリーンロック無効化（DPMS無効化） ==="
echo "[*] Disabling display power management (DPMS)..."
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled --create -t bool -s false
echo "[✔] DPMS disabled."
echo ""

echo "※ 注意 ※"
echo "「Enable Screensaver」の無効化は自動化できませんでした。"
echo "GUIで以下を手動で設定してください："
echo " 1. 設定マネージャー（Settings Manager）を開く"
echo " 2. 「Screensaver」または「スクリーンセーバー」設定を開く"
echo " 3. 「Enable Screensaver」のチェックを外す"
echo ""
echo "再起動後に設定が反映される可能性があります。"
echo ""

echo "=== [4/4] sudo パスワード不要設定 ==="
USERNAME=kali

sudo usermod -aG sudo $USERNAME

echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USERNAME-nopasswd >/dev/null
sudo chmod 440 /etc/sudoers.d/$USERNAME-nopasswd

echo "Passwordless sudo setup completed for user $USERNAME"

