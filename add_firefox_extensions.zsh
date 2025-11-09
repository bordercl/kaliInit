#!/usr/bin/env zsh
# Kali Linux: Firefox ESR に FoxyProxy と Wappalyzer を自動追加 (zsh版)

POLICY_FILE="/usr/share/firefox-esr/distribution/policies.json"
BACKUP_FILE="/usr/share/firefox-esr/distribution/policies.json.bak_$(date +%Y%m%d_%H%M%S)"

# jq が無ければインストール
if ! command -v jq >/dev/null 2>&1; then
  echo "[*] jq が見つかりません。インストールします..."
  sudo apt update && sudo apt install -y jq
fi

# ファイル存在チェック
if [[ ! -f ${POLICY_FILE} ]]; then
  echo "[ERROR] ${POLICY_FILE} が見つかりません。パスを確認してください。"
  exit 1
fi

# バックアップ作成
echo "[+] バックアップを作成中: ${BACKUP_FILE}"
sudo cp -- "${POLICY_FILE}" "${BACKUP_FILE}"

# Extensions セクションを追加（既存の policies を壊さないように jq でマージ）
echo "[+] Extensions セクションを追加中..."

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
}' "${POLICY_FILE}" | sudo tee "${POLICY_FILE}" > /dev/null

if [[ $? -ne 0 ]]; then
  echo "[ERROR] policies.json の更新中にエラーが発生しました。バックアップファイルを確認してください: ${BACKUP_FILE}"
  exit 2
fi

echo ""
echo "[+] 完了しました！"
echo "    - 元ファイルのバックアップ: ${BACKUP_FILE}"
echo "    - 追加済みアドオン: FoxyProxy, Wappalyzer"
echo ""
echo "[*] 次のコマンドで Firefox ESR を再起動してください:"
echo "    firefox-esr &"
echo ""
echo "⚠️ 注意: ツールバーへのピン留め（固定）は自動では行えません。"
echo "   Firefoxを起動後、ツールバーを右クリックして手動でピン留めしてください。"

