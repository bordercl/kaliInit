#!/usr/bin/env zsh

# ~/.zshrcに/opt/tools/binがPATHに含まれているか確認し、なければ追加するスクリプト

TARGET_PATH="/opt/tools/bin"
ZSHRC="$HOME/.zshrc"

if ! echo "$PATH" | grep -q "$TARGET_PATH" ; then
  echo "export PATH=\"$TARGET_PATH:\$PATH\"" >> "$ZSHRC"
  echo "✅ $TARGET_PATH を PATH に追加しました。"
else
  echo "✅ $TARGET_PATH はすでに PATH に含まれています。"
fi

echo ""
echo "🔍 現在の PATH:"
echo "$PATH"
echo ""
echo "⚠️ PATH に $TARGET_PATH が含まれていない場合は、手動で以下を実行してください："
echo "   source ~/.zshrc"

