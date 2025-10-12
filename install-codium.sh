#!/bin/bash

# VSCodium GPGキーを取得して配置
echo "[*] Adding GPG key..."
curl -fsSL https://repo.vscodium.dev/vscodium.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium.gpg

# リポジトリファイルを追加
echo "[*] Adding VSCodium repository..."
sudo curl -fsSL https://repo.vscodium.dev/vscodium.sources -o /etc/apt/sources.list.d/vscodium.sources

# パッケージリストを更新
echo "[*] Updating package list..."
sudo apt update

# codium をインストール
echo "[*] Installing codium..."
sudo apt install -y codium

# デスクトップにショートカット作成
echo "[*] Creating desktop shortcut..."
cp /usr/share/applications/codium.desktop ~/Desktop/
chmod +x ~/Desktop/codium.desktop

# 完了メッセージ
echo "[✔] VSCodium installation complete."
echo "    - Launch via: codium"
echo "    - Or click the desktop icon: ~/Desktop/codium.desktop"
