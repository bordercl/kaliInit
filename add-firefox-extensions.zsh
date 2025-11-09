#!/bin/zsh

# paths
POLICY_FILE="/usr/share/firefox-esr/distribution/policies.json"
BACKUP_FILE="/usr/share/firefox-esr/distribution/policies.json.bak"
TMP_FILE="/tmp/policies_new.json"

# 1️⃣ バックアップ
echo "バックアップ作成: $BACKUP_FILE"
sudo cp -- "$POLICY_FILE" "$BACKUP_FILE"

# 2️⃣ Extensions 追加
echo "FoxyProxy と Wappalyzer を policies.json に追加中..."
sudo jq '.policies += {
  "Extensions": {
    "Install": [
      "https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-standard/latest.xpi",
      "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi"
    ],
    "Locked": [
      "foxyproxy@eric.h.jung",
      "wappalyzer@crunchlabz.com"
    ]
  }
}' "$POLICY_FILE" | sudo tee "$TMP_FILE" > /dev/null

# 3️⃣ 内容確認
echo "更新内容:"
cat "$TMP_FILE"

# 4️⃣ 上書き
echo "policies.json を更新..."
sudo cp "$TMP_FILE" "$POLICY_FILE"

# 5️⃣ Firefox 再起動
echo "Firefox を再起動します..."
firefox-esr &

# 6️⃣ 注意メッセージ
echo "⚠️ FoxyProxy と Wappalyzer のアイコンは手動でツールバーにピン留めしてください。"

