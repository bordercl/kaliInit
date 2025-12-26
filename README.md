# kaliInit

### curl を使用する場合

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | zsh
```

### wget を使用する場合

```sh
wget -qO- https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-kali.sh | zsh
```

### 日本語入力(Anthy)

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-anthy-ja.sh | zsh
```
### smbfs

```sh
sudo curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/setup-cifs-mount.sh | sudo zsh -s -- <IP> <USERNAME> <PASSWORD>
```

### sudo 必須

```sh
curl -sSL https://raw.githubusercontent.com/bordercl/kaliInit/main/enable-services.zsh | sudo zsh
```
