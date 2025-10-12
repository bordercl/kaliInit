#!/bin/bash

# GitHub上のpackages.txtのURL（あなたのリポジトリのraw URLに書き換えてください）
URL="https://raw.githubusercontent.com/ユーザー名/リポジトリ名/ブランチ名/packages.txt"

# 一時ファイル
TMPFILE=$(mktemp)

# ダウンロード
echo "Downloading packages list from GitHub..."
curl -sSL "$URL" -o "$TMPFILE"

if [[ $? -ne 0 ]]; then
  echo "Failed to download packages list."
  exit 1
fi

# インストール
echo "Installing packages..."
xargs -a "$TMPFILE" sudo apt install -y

# 後始末
rm "$TMPFILE"

echo "Done."

