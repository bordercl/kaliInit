#!/usr/bin/zsh
# ================================================================
# Visual Studio Code Install Script (for Debian-based distros)
# Author: bordercl
# References:
#   https://code.visualstudio.com/docs/setup/linux
#   https://zenn.dev/hinaraya/articles/5f965841c576b4
# ================================================================

echo "[*] Starting Visual Studio Code installation..."

# Microsoft リポジトリの追加
echo "[*] Adding Microsoft repository..."
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt update -y >/dev/null 2>&1
sudo apt install -y wget gpg apt-transport-https >/dev/null 2>&1

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg

# パッケージ更新 & インストール
echo "[*] Installing VSCode..."
sudo apt update -y >/dev/null 2>&1
sudo apt install -y code >/dev/null 2>&1

# デスクトップショートカット作成
echo "[*] Creating desktop shortcut..."
if [ -f /usr/share/applications/code.desktop ]; then
  mkdir -p "$HOME/Desktop"
  cp /usr/share/applications/code.desktop "$HOME/Desktop/"
  chmod +x "$HOME/Desktop/code.desktop"
else
  echo "[!] Warning: /usr/share/applications/code.desktop not found."
fi

# 完了メッセージ
echo "[✔] Visual Studio Code installation complete."
echo "    - Launch via: code"
echo "    - Or click the desktop icon: ~/Desktop/code.desktop"
