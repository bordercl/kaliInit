# kaliInit

## 使い方

* curl を使用する場合
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | sudo bash
```

* wget を使用する場合
```sh
wget -qO- https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | sudo bash
```

⸻

## コマンド一覧

📦 Package Install

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/install-packages.sh | zsh
```

🧩 VS code Install

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/install-vscode.sh | zsh
```

🌐 Firefox about:config

```
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-firefox-aboutConfig.sh | zsh
```

⌨️ Terminator Shortcuts

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-terminator-shortcuts.zsh | zsh
```

🇯🇵 Japanese Input (Anthy)

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-anthy-ja.sh | zsh
```

⸻

### sudo 必須

🔐 Autologin

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-autologin.sh | sudo bash
```

⚙️ Services Enable

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-services.zsh | sudo zsh
```

🗂 CIFS Mount

```sh
sudo curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-cifs-mount.sh | sudo zsh -s -- <IP> <USERNAME> <PASSWORD>
```
