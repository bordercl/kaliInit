#!/bin/zsh
# setup-terminator-shortcuts.zsh
#
# このスクリプトの目的：
# 1. 既存の ~/.config/terminator/config をバックアップ (.orig)
#    → 元の設定を保持して安全に編集可能（※既にバックアップがある場合はスキップ）
# 2. [keybindings] セクションが既にある場合はその下にキーバインドを追記
#    ない場合は末尾に追加
# 3. Terminator のキーバインド設定
#    デフォルト → カスタム設定
#       - copy       : Shift+Ctrl+C → Ctrl+C
#       - paste      : Shift+Ctrl+V → Ctrl+V
#       - split_auto : Shift+Ctrl+A → Shift+Super+A
#       - split_horiz: Shift+Ctrl+O → Shift+Super+H
#       - split_vert : Shift+Ctrl+E → Shift+Super+V
#       - new_tab    : Shift+Ctrl+T → Super+T
#       - group_tab  : Super+T → 空に変更（無効化）
#       - close_term : Shift+Ctrl+W → Ctrl+X
#       - new_window : Shift+Ctrl+I → Super+N
#
# 4. XFCE の /commands/custom/<Super>t を削除
#    → Super+T がデスクトップ環境に予約されるのを解除（default は変更しない）
#
# ===== XFCE GUIでの削除手順 =====
# GUI > Settings > Keyboard > Application Shortcuts
#   Command：exo-open --launch TerminalEmulator
#   Shortcut：Super+T
#   → これを選択して [Remove] をクリック
#
# ===== ターミナルでの削除 =====
# xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>t" -r
#
# 5. 最後に Terminator の再起動を案内

# 実行時に表示する ASCII アート
cat << "EOF"
  __                       .__               __                
_/  |_  ___________  _____ |__| ____ _____ _/  |_  ___________ 
\   __\/ __ \_  __ \/     \|  |/    \\__  \\   __\/  _ \_  __ \
 |  | \  ___/|  | \/  Y Y  \  |   |  \/ __ \|  | (  <_> )  | \/
 |__|  \___  >__|  |__|_|  /__|___|  (____  /__|  \____/|__|   
           \/            \/        \/     \/                    
EOF

# ────────────── スクリプト本体 ──────────────

CONFIG_DIR="$HOME/.config/terminator"
CONFIG_FILE="$CONFIG_DIR/config"
BACKUP_FILE="$CONFIG_FILE.orig"

mkdir -p "$CONFIG_DIR"

# バックアップ（既に*.origがあればスキップ）
if [ -f "$CONFIG_FILE" ]; then
    if [ -f "$BACKUP_FILE" ]; then
        echo "バックアップファイルが既に存在するためコピーをスキップしました: $BACKUP_FILE"
    else
        cp "$CONFIG_FILE" "$BACKUP_FILE"
        echo "既存の設定ファイルをバックアップしました: $BACKUP_FILE"
    fi
fi

# 設定が既にあるか確認（copy を例にチェック）
if grep -q "copy = <Primary>c" "$CONFIG_FILE" 2>/dev/null; then
    echo "Terminatorのキーバインドは既に設定済みのため追記をスキップします"
else
    # 追記内容を一時ファイルに書き込む
    TMP_FILE=$(mktemp)
    cat > "$TMP_FILE" <<EOL
  new_tab = <Super>t
  split_auto = <Shift><Super>a
  split_horiz = <Shift><Super>h
  split_vert = <Shift><Super>v
  close_term = <Primary>x
  copy = <Primary>c
  paste = <Primary>v
  group_tab = ""
  new_window = <Super>n
EOL

    # [keybindings] の行番号を取得
    LINE_NUM=$(grep -n "^\[keybindings\]" "$CONFIG_FILE" | cut -d: -f1)

    if [ -n "$LINE_NUM" ]; then
        LINE_NUM=$((LINE_NUM + 1))
        sed -i "${LINE_NUM}r $TMP_FILE" "$CONFIG_FILE"
        echo "[keybindings] セクションの下に追記しました"
    else
        echo "" >> "$CONFIG_FILE"
        echo "[keybindings]" >> "$CONFIG_FILE"
        cat "$TMP_FILE" >> "$CONFIG_FILE"
        echo "[keybindings] セクションを末尾に追加しました"
    fi

    rm "$TMP_FILE"
fi

# XFCEのSuper+Tショートカットを削除（custom のみ）
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>t" -r
echo "XFCEのカスタム Super+T ショートカット（/commands/custom/<Super>t）を削除しました"

# 参考：確認コマンド
echo "確認コマンド："
echo '  xfconf-query -c xfce4-keyboard-shortcuts -lv | grep "/commands/custom/<Super>t"'

echo "完了！Terminatorを再起動してください。"