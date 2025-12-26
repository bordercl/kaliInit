#!/usr/bin/env zsh
set -e

if [[ $EUID -eq 0 ]]; then
  echo "[-] Do NOT run as root"
  exit 1
fi

# 起動
firefox --headless >/dev/null 2>&1 &
sleep 5

# プロファイルディレクトリを1つ取得（esr優先）
PROFILE_DIR=$(ls -d ~/.mozilla/firefox/*.default-esr(N[1]))

if [[ -z "$PROFILE_DIR" ]]; then
  echo "[-] Firefox ESR profile not found"
  pkill firefox || true
  exit 1
fi

USER_JS="$PROFILE_DIR/user.js"

sed -i '/browser.urlbar.trimHttps/d' "$USER_JS" 2>/dev/null || true
sed -i '/browser.urlbar.trimURLs/d' "$USER_JS" 2>/dev/null || true

cat <<'EOF' >> "$USER_JS"
user_pref("browser.urlbar.trimHttps", false);
user_pref("browser.urlbar.trimURLs", false);
EOF

# 終了
pkill firefox || true

echo "[+] Done. Restart Firefox normally."
