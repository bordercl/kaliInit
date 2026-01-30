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

🖥 VMware Shared Folder（bind mount）
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/vmshare.sh | zsh
```

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

以下のスクリプトは **root 権限での実行が前提**です。  
そのため、`curl | sudo zsh` の形式で実行してください。

✔ 条件  
- `/etc` 配下の設定ファイルのみを書き換える  
- `systemd` / `service` の操作のみを行う  
- `$HOME` を一切使用しない  
- ユーザー依存の設定を含まない  

上記条件を満たすため、**root 実行でも安全に動作する設計**になっています。

🔐 LightDM 自動ログイン有効化
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-autologin.sh | sudo zsh
```

⚙️ サービス有効化
```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-services.zsh | sudo zsh
```
