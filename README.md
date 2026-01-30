# kaliInit

## 使い方

* curl を使用する場合
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | zsh
```

* wget を使用する場合
```sh
wget -qO- https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | zsh
```

⸻

## コマンド一覧

📦 パッケージ一括インストール
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/install-packages.sh | zsh
```

🧑‍💻 Visual Studio Code インストール
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/install-vscode.sh | zsh
```

🧩 Firefox アドオン追加
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/add-firefox-extensions.zsh | zsh
```

🌐 Firefox about:config 設定
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-firefox-aboutConfig.sh | zsh
```

🖥 Terminator ショートカット設定
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-terminator-shortcuts.zsh | zsh
```

🈶 日本語入力（Anthy）
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-anthy-ja.sh | zsh
```

⸻

### sudo 必須

🔐 LightDM 自動ログイン有効化
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-autologin.sh | sudo bash
```

⚙️ サービス有効化
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-services.zsh | sudo zsh
```

🗂 CIFS（SMB）マウント設定
```sh
sudo curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-cifs-mount.sh | sudo zsh -s -- <IP> <USERNAME> <PASSWORD>
```
