# Independent Challenges

## 例(最後に削除)

### Service Enumeration

**Port Scan Results**

Server IP Address | Ports Open
------------------|----------------------------------------
192.168.1.1       | **TCP**: 21,22,25,80,443

**FTP Enumeration**

利用可能な FTP サービスを手動で列挙したところ、ジョンは、リモート バッファ オーバーフローの脆弱性がある古いバージョン 2.3.4 が実行されていることに気付きました。

### Initial Access - Buffer Overflow

**Vulnerability Explanation（脆弱性の説明）:** Ability Server 2.34 には、STOR フィールドにおけるバッファオーバーフローの脆弱性が存在します。
攻撃者はこの脆弱性を悪用し、任意のリモートコード実行を引き起こし、システムを完全に制御する可能性があります。

**Vulnerability Fix（脆弱性の修正）:** Ability Server の発行者は、この既知の問題を修正するパッチを公開しました。
こちらから入手できます: http://www.code-crafters.com/abilityserver/

**Severity（深刻度）:** Critical

**Steps to reproduce the attack（攻撃の再現手順）:** オペレーティングシステムは、既知の公開エクスプロイトとは異なっていました。
コード実行を成功させるには、エクスプロイトを書き換える必要がありました。エクスプロイトが書き換えられると、システムに対して標的型攻撃が実行され、ジョンはシステムの完全な管理者権限を取得しました。The operating system was different from the known public exploit.
A rewritten exploit was needed in order for successful code execution to occur. Once the exploit was rewritten, a targeted attack was performed on the system which gave John full administrative access over the system.

**Proof of Concept Code Here（概念実証コード）:** 既存のエクスプロイトに対する修正が必要であり、赤で強調表示されています

```python
XXXXX
```

**Proof Screenshot（実証スクリーンショット）:**

![ImgPlaceholder](img/placeholder-image-300x225.png)

\newpage

### Privilege Escalation - MySQL Injection

**Vulnerability Explanation（脆弱性の説明）:** 標的への足掛かりを築いた後、ジョンはローカルで複数のアプリケーションが稼働していることに気付きました。そのうちの1つ、ポート80番のカスタムWebアプリケーションは、SQLインジェクション攻撃を受けやすい状態でした。
ポートフォワーディングにChiselを使用することで、ジョンはWebアプリケーションにアクセスできました。
侵入テストの実行中、ジョンはtaxidクエリ文字列パラメータにエラーベースのMySQLインジェクションがあることに気付きました。
テーブルデータを列挙している際に、ジョンはデータベースのルートアカウントのログイン情報とパスワードを暗号化されていない状態で抽出することに成功しました。これらの認証情報は、システム上の管理者ユーザーアカウントのユーザー名とパスワードと一致しており、ジョンはRDPを使用してリモートログインすることができました。
これにより、オペレーティングシステムとシステムに含まれるすべてのデータへの侵入に成功しました。

**Vulnerability Fix（脆弱性の修正）:** これはカスタムWebアプリケーションであるため、特定のアップデートだけではこの問題は適切に解決されません。
アプリケーションは、ユーザー入力データを適切にサニタイズし、ユーザーが制限されたユーザーアカウントで実行していること、そしてSQLデータベースに保存されている機密データが適切に暗号化されていることを確認するようにプログラムする必要があります。
カスタムエラーメッセージの使用を強くお勧めします。エラーが表示されない場合、攻撃者が特定の脆弱性を悪用することはより困難になります。

**Severity（深刻度）:** Critical

**Steps to reproduce the attack（攻撃の再現手順）:**

**Proof of Concept Code Here（概念実証コード）:**

```sql
XXXXX
```

完全な Windows バッファ オーバーフロー コードについては、付録 1 を参照してください。

### Post-Exploitation

**System Proof Screenshot:**

![ImgPlaceholder](img/placeholder-image-300x225.png)

## Target #1 - 192.168.x.x

### Service Enumeration

Server IP Address | Ports Open
------------------|----------------------------------------
192.168.1.1       | **TCP**: 21,22,25,80,443
**UDP**: 1434,161

**Nmap Scan Results:**

*初期シェルの脆弱性を悪用*

*最初のシェルがどこから取得されたかについての追加情報*

### Initial Access - XXX

**Vulnerability Explanation（脆弱性の説明）:**

**Vulnerability Fix（脆弱性の修正）:**

**Severity（深刻度）:**

**Steps to reproduce the attack（攻撃の再現手順）:**

**Proof of Concept Code（概念実証コード）:**

**Proof Screenshot（実証スクリーンショット）:**

**local.txt content（local.txt の内容）:**

### Privilege Escalation - XXX

**Vulnerability Explanation（脆弱性の説明）:**

**Vulnerability Fix（脆弱性の修正）:**

**Severity（深刻度）:**

**Steps to reproduce the attack（攻撃の再現手順）:**

**Proof of Concept Code（概念実証コード）:**

### Post-Exploitation

**Proof Screenshot（実証スクリーンショット）:**

**proof.txt content（proof.txt の内容）:**

# Active Directory Set

**Port Scan Results**

IP Address | Ports Open
------------------|----------------------------------------
192.168.x.x       | **TCP**: 1433,3389\
**UDP**: 1434,161
192.168.x.x       | **TCP**: 1433,3389\
**UDP**: 1434,161
192.168.x.x       | **TCP**: 1433,3389\
**UDP**: 1434,161

## Hostname1: 192.168.x.x

### Initial Access - XXX

**Vulnerability Explanation（脆弱性の説明）:**

**Vulnerability Fix（脆弱性の修正）:**

**Severity（深刻度）:**

**Steps to reproduce the attack（攻撃の再現手順）:**

**Proof of Concept Code（概念実証コード）:**

**Proof Screenshot（実証スクリーンショット）:**

**local.txt content（local.txt の内容）:**

### Privilege Escalation - XXX

**Vulnerability Explanation（脆弱性の説明）:**

**Vulnerability Fix（脆弱性の修正）:**

**Severity（深刻度）:**

**Steps to reproduce the attack（攻撃の再現手順）:**

**Proof of Concept Code（概念実証コード）:**

### Post-Exploitation

**Proof Screenshot（実証スクリーンショット）:**

**proof.txt content（proof.txt の内容）:**

# Additional Items Not Mentioned in the Report

This section is placed for any additional items that were not mentioned in the overall report.
