#!/usr/bin/env zsh

URL="https://raw.githubusercontent.com/bordercl/kaliInit/main/packages.txt"
TMPFILE=$(mktemp)

echo "Downloading packages list from GitHub..."
if ! curl -sSL "$URL" -o "$TMPFILE"; then
  echo "Failed to download packages list."
  exit 1
fi

echo "Updating package list..."
sudo apt update

echo "Installing packages..."
grep -vE '^\s*#|^\s*$' "$TMPFILE" | sed 's/\s*#.*//' | tee /dev/stderr | xargs sudo apt install -y

rm "$TMPFILE"

DESKTOP_DIR="$HOME/Desktop"

copy_shortcut() {
  local src="$1"
  local dst="$DESKTOP_DIR/$(basename "$src")"

  if [ -f "$src" ]; then
    echo "[*] Copying shortcut: $src -> $dst"
    cp "$src" "$dst"
    chmod +x "$dst"
  else
    echo "[!] Shortcut not found: $src"
  fi
}

copy_shortcut "/usr/share/applications/terminator.desktop"
#copy_shortcut "/usr/share/applications/com.gexperts.Tilix.desktop"
copy_shortcut "/usr/share/applications/kali-ghidra.desktop"

echo "[*] All done. Shortcuts are in $DESKTOP_DIR"

