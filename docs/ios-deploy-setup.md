# iOS TestFlight 自動デプロイ — セットアップ手順

`vX.Y.Z` タグを push すると、GitHub Actions（macOS ランナー）が iOS アプリをビルド・署名し
TestFlight へアップロードします。App Store 公開申請は手動です。

初回に **一度だけ** 以下の Apple 側準備と GitHub Secrets 登録が必要です。

---

## 0. 前提
- Apple Developer Program メンバーシップ（Team ID: `V2B43LMURK` 設定済み）
- Bundle ID: `com.ishtos.doppel`

## 1. App Store Connect にアプリ登録
1. https://appstoreconnect.apple.com → マイApp → ＋ → 新規App
2. プラットフォーム: iOS、バンドルID: `com.ishtos.doppel` を選択（未登録なら Developer サイトで App ID を先に作成）
3. SKU（任意の一意文字列）を入力して作成

## 2. App Store Connect API キー（アップロード用）
1. App Store Connect → ユーザーとアクセス → 「Integrations（統合）」→ App Store Connect API
2. 「＋」でキー生成。ロールは **App Manager** 以上
3. 控える：**Issuer ID**、**Key ID**、ダウンロードした **`AuthKey_XXXX.p8`**（再DL不可）

## 3. 配布証明書（Apple Distribution）
- Xcode: Settings → Accounts → Manage Certificates → ＋ → Apple Distribution
- または Developer サイトで CSR から作成
- キーチェーンアクセスで秘密鍵ごと **`.p12`** として書き出し（パスワードを設定）

## 4. Provisioning Profile（App Store 用）
1. Developer サイト → Profiles → ＋ → **App Store** 配布
2. App ID = `com.ishtos.doppel`、上記の配布証明書を選択
3. **プロファイル名を控える**（例: `Doppel App Store`）→ Secret `IOS_PROVISION_PROFILE_NAME` に使う
4. `.mobileprovision` をダウンロード

## 5. GitHub Secrets を登録
リポジトリ → Settings → Secrets and variables → Actions → New repository secret

| Secret 名 | 値 | 作り方 |
|---|---|---|
| `APPLE_TEAM_ID` | `V2B43LMURK` | そのまま |
| `IOS_DIST_CERT_P12_BASE64` | 配布証明書 .p12 の Base64 | `base64 -i dist.p12 \| pbcopy` |
| `IOS_DIST_CERT_PASSWORD` | .p12 書き出し時のパスワード | — |
| `IOS_PROVISION_PROFILE_BASE64` | .mobileprovision の Base64 | `base64 -i profile.mobileprovision \| pbcopy` |
| `IOS_PROVISION_PROFILE_NAME` | プロファイル名（手順4-3） | 例: `Doppel App Store` |
| `ASC_KEY_ID` | API Key ID | 手順2 |
| `ASC_ISSUER_ID` | API Issuer ID | 手順2 |
| `ASC_KEY_P8_BASE64` | AuthKey_XXXX.p8 の Base64 | `base64 -i AuthKey_XXXX.p8 \| pbcopy` |

> macOS の `base64` は改行を含みません。Linux は `base64 -w0 <file>` を使用。

## 6. デプロイ実行
```bash
# pubspec.yaml の version(+ビルド番号) を上げてコミットしてから
git tag v1.0.1
git push origin v1.0.1
```
または GitHub → Actions → 「Deploy iOS (TestFlight)」→ Run workflow（手動）。

数分後、App Store Connect → TestFlight にビルドが現れます（処理に数分）。内部テスターに配信されます。

---

## トラブルシュート
| 症状 | 対処 |
|---|---|
| `No signing certificate "iOS Distribution" found` | `.p12` に秘密鍵が含まれているか、証明書種別が Apple Distribution か確認 |
| `Provisioning profile ... doesn't match` | `IOS_PROVISION_PROFILE_NAME` がプロファイル名と完全一致しているか、App ID/証明書が対応しているか |
| `Redundant binary upload / build number exists` | `pubspec.yaml` の `+N`（ビルド番号）を上げる |
| `Authentication credentials are missing` | `ASC_*` の3 Secret を再確認（.p8 は Base64 化） |
| Xcode バージョン不整合でビルド失敗 | ワークフローの `runs-on: macos-15` を調整（`macos-14` 等） |

## 運用メモ
- バージョンは `pubspec.yaml` の `version: X.Y.Z+N`。`N`（ビルド番号）は毎回インクリメント。
- 外部テスター配信や App Store 公開は App Store Connect 上で手動操作（本パイプライン対象外）。
