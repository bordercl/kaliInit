#!/bin/zsh

INI="$HOME/.zshrc"
LINE='export PATH="/opt/tools/bin:$PATH"'

# すでに追加されていないか確認
if ! grep -Fxq "$LINE" "$INI"; then
  echo "$LINE" >> "$INI"
  echo "✅ /opt/tools/bin を PATH に追加しました。"
else
  echo "ℹ️ 既に PATH に /opt/tools/bin が追加されています。"
fi

# 設定を反映（現在のシェルにのみ）
source "$INI"

