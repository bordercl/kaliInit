#!/bin/bash

INI="$HOME/.config/qterminal.org/qterminal.ini"

echo "🔧 QTerminal のショートカットキーを変更します..."

# Ctrl+Shift → Ctrl に変更
sed -i 's/Add%20Tab=Ctrl+Shift+T/Add%20Tab=Ctrl+T/' "$INI"
sed -i 's/Close%20Tab=Ctrl+Shift+W/Close%20Tab=Ctrl+W/' "$INI"
sed -i 's/Collapse%20Subterminal=Ctrl+Shift+E/Collapse%20Subterminal=Ctrl+E/' "$INI"
sed -i 's/Copy%20Selection=Ctrl+Shift+C/Copy%20Selection=Ctrl+C/' "$INI"
sed -i 's/Find=Ctrl+Shift+F/Find=Ctrl+F/' "$INI"
sed -i 's/New%20Window=Ctrl+Shift+N/New%20Window=Ctrl+N/' "$INI"
sed -i 's/Paste%20Clipboard=Ctrl+Shift+V/Paste%20Clipboard=Ctrl+V/' "$INI"
sed -i 's/Toggle%20Bookmarks=Ctrl+Shift+B/Toggle%20Bookmarks=Ctrl+B/' "$INI"
sed -i 's/Toggle%20Menu=Ctrl+Shift+M/Toggle%20Menu=Ctrl+M/' "$INI"

# |以降を削除
sed -i 's/Move%20Tab%20Left=Alt+Shift+Left|Ctrl+PgUp/Move%20Tab%20Left=Alt+Shift+Left/' "$INI"
sed -i 's/Move%20Tab%20Right=Alt+Shift+Right|Ctrl+PgDown/Move%20Tab%20Right=Alt+Shift+Right/' "$INI"

# horizontal / vertical に変更（キー操作）
sed -i 's/Split%20View%20Left-Right=Ctrl+Shift+R/Split%20View%20Left-Right=Ctrl+Shift+V/' "$INI"
sed -i 's/Split%20View%20Top-Bottom=Ctrl+Shift+D/Split%20View%20Top-Bottom=Ctrl+Shift+H/' "$INI"

echo "✅ 完了しました！QTerminal を再起動して変更を反映してください。"

echo
echo "QTerminal を再起動します..."
echo "pkill qterminal || true"
echo "qterminal &"


