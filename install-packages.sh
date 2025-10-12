#!/bin/bash -x

URL="https://raw.githubusercontent.com/bordercl/kaliInit/main/packages.txt"

TMPFILE=$(mktemp)

echo "Downloading packages list from GitHub..."
curl -sSL "$URL" -o "$TMPFILE"

if [[ $? -ne 0 ]]; then
  echo "Failed to download packages list."
  exit 1
fi

echo "Updating package list..."
sudo apt update

echo "Installing packages..."

# コメント行と空行を除外し、パッケージ名のみ抽出してインストール
grep -vE '^\s*#|^\s*$' "$TMPFILE" | sed 's/\s*#.*//' | xargs sudo apt install -y

rm "$TMPFILE"

echo "Done."

