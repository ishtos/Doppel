# 設計書: レシート検証（S2強化）＋ Worker レート制限（S1強化）

**日付:** 2026-07-12
**対象:** 残タスク2件（`claudedocs/analysis_20260711.md` 由来）
**形式:** アーキテクチャ + API仕様 + データモデル（実装は `/sc:implement`）
**前提:** 既存の Cloudflare Worker（`server/cloudflare-worker`）を拡張。iOS を主対象、Android は並行設計として明記。

---

## 全体像

```
                         ┌────────────────────── Cloudflare Worker (拡張) ─────────────────────┐
  Flutter app            │  /v1/*            → OpenAI プロキシ（既存 S1）                        │
  (in_app_purchase) ──▶  │  /iap/verify      → Apple/Google でレシート検証 → D1 upsert          │
                         │  /iap/entitlement → D1 の権利状態を返す（アプリが起動時に同期）        │
   App Store /           │  /iap/apple/notifications  ← App Store Server Notifications V2 (JWS) │
   Play Billing  ─────▶  │  /iap/google/notifications ← Google RTDN (Pub/Sub push)             │
                         │  ratelimit binding + WAF  → /v1/* と /iap/verify を保護              │
                         └────────────── D1 (entitlements)  +  KV (daily cost cap) ────────────┘
```

設計の要点:
- **権利の正本はサーバ（D1）**。アプリの `isPremium` は「サーバ権利のキャッシュ」に降格。クライアントの `grantsPremium` はヒントに留め、最終判断はサーバが返す `entitled`。
- サブスクは**時間経過で状態が変わる**（更新・失効・返金）ため、**サーバ通知（ASSN V2 / RTDN）**で受動的に追従し、アプリは起動時に `/iap/entitlement` で同期。
- 匿名アプリ（アカウント無し）なので、端末ごとの安定IDとして **`appAccountToken`（UUID）** を導入し、Apple の `originalTransactionId` と突き合わせる。

---

# 設計1: サーバサイド・レシート検証（S2強化）

## 現状 → 目標

| | 現状 | 目標 |
|---|---|---|
| 権利判定 | クライアント `grantsPremium`（改造で回避可能） | サーバが Apple/Google で検証し D1 に保存 |
| 更新/失効/返金 | 検知できない | サーバ通知で自動反映 → アプリ起動時に同期 |
| `isPremium` | ローカルの真実 | サーバ権利のキャッシュ（オフライン用） |

## 識別子戦略（重要）

アカウントが無いので、購入と端末を結ぶキーが必要。

- 初回起動時に `appAccountToken`（UUIDv4）を生成し `SharedPreferences` に保存。
- 購入時 `PurchaseParam(applicationUserName: appAccountToken)` で Apple/Google に渡す（Apple は `appAccountToken` として signedTransaction に格納される）。
- サーバは Apple から返る `originalTransactionId` を主キー、`appAccountToken` を副キーとして D1 に保存。
- 復元（機種変更/再インストール）は Apple ID 側で紐づくため、`/iap/verify` の再送 or 通知で `originalTransactionId` が一致し権利が復活。新端末の `appAccountToken` を紐づけ直す。

> 将来ユーザーアカウントを導入する場合は、キーを `userId` に置換すれば同設計が流用可能。

## API 仕様（Worker 追加エンドポイント）

### `POST /iap/verify`  （アプリ→Worker, `X-App-Token` 必須）
購入直後にクライアントが呼ぶ。サーバが Apple/Google で検証し D1 を更新、最新の権利を返す。

Request:
```json
{
  "platform": "apple" | "google",
  "appAccountToken": "uuid",
  "productId": "com.ishtos.doppel.premium.monthly",
  "verificationData": "<base64 receipt (StoreKit1) or JWS (StoreKit2) / Play purchaseToken>"
}
```
Response 200:
```json
{ "entitled": true, "productId": "...", "expiresDate": "2026-08-11T00:00:00Z", "environment": "Production" }
```
- 4xx: `invalid_receipt` / `unauthorized`（X-App-Token不一致）。

### `GET /iap/entitlement?appAccountToken=uuid`  （アプリ→Worker, `X-App-Token` 必須）
起動時/フォアグラウンド復帰時にアプリが呼び、サーバ権利へ同期。
```json
{ "entitled": false, "reason": "expired", "expiresDate": "2026-07-01T..." }
```

### `POST /iap/apple/notifications`  （Apple→Worker, `X-App-Token` 無し）
App Store Server Notifications V2 の受信口。**JWS署名を検証**（x5c チェーン → Apple Root CA G3）してから `notificationType`（`SUBSCRIBED`/`DID_RENEW`/`EXPIRED`/`DID_CHANGE_RENEWAL_STATUS`/`REFUND` など）で D1 を更新。常に `200` を返す（Apple の再送を防ぐ）。

### `POST /iap/google/notifications`  （Google Pub/Sub→Worker）
Play RTDN の push 購読先。`subscriptionNotification.purchaseToken` で Play Developer API を照会し D1 を更新。

## データモデル（Cloudflare D1 / SQLite）

```sql
CREATE TABLE entitlements (
  app_account_token       TEXT PRIMARY KEY,        -- 端末/インストール識別
  platform                TEXT NOT NULL,           -- 'apple' | 'google'
  original_transaction_id TEXT,                    -- Apple: 復元の突合キー
  product_id              TEXT NOT NULL,
  status                  TEXT NOT NULL,           -- 'active'|'expired'|'in_grace'|'refunded'|'revoked'
  expires_date            INTEGER,                 -- epoch ms
  environment             TEXT NOT NULL,           -- 'Production' | 'Sandbox'
  updated_at              INTEGER NOT NULL
);
CREATE INDEX idx_entitlements_otid ON entitlements(original_transaction_id);
```
- `entitled = status IN ('active','in_grace') AND (expires_date IS NULL OR expires_date > now)`。
- KV でも実装可能だが、`original_transaction_id` での逆引き（通知処理）に索引が要るため **D1 を推奨**。

## 検証ロジック

**Apple（App Store Server API）**
- Base: `https://api.storekit.itunes.apple.com`（本番）/ `...storekit-sandbox...`（サンドボックス）。まず本番→404/環境不一致ならサンドボックスへフォールバック。
- `GET /inApps/v1/subscriptions/{originalTransactionId}` で最新のサブスク状態（signed JWS）を取得。
- 認証: **ES256 JWT**（App Store Connect の In-App Purchase 用APIキー: Key ID / Issuer ID / .p8、`bid`=バンドルID クレーム）。
  - ⚠️ 既存の `ASC_KEY_*`（fastlane用, App Manager）とは**別に、In-App Purchase 権限のキーを作成推奨**。
- 通知/トランザクションの JWS 検証は `jose`（Workers対応）で署名検証 + x5c を Apple Root CA G3 まで検証。

**Google（Play Developer API）**
- サービスアカウント（OAuth2, JWT）で `purchases.subscriptionsv2.get` を呼び `purchaseToken` を検証。
- RTDN は Google Cloud Pub/Sub の push を Worker で受ける（Pub/Sub の OIDC トークン検証）。

## クライアント変更（アプリ側）

- `appAccountToken` の生成・保存（`SharedPreferences`）。`PurchaseParam(applicationUserName: appAccountToken)`。
- 購入成功ハンドラ: `grantsPremium` で暫定表示 → `POST /iap/verify` の `entitled` で確定（`setPremium(server結果)`）。
- 起動時 / 復帰時: `GET /iap/entitlement` で同期（更新・失効・返金の反映）。
- オフライン時は最後に取得した権利をキャッシュとして使用（`SharedPreferences` に `entitled`+`expiresDate`）。
- `purchase_service.dart` に「サーバ検証クライアント」を注入（テスト用に `http.Client` 差し替え可能に、S1と同様）。

## セキュリティ / 信頼境界

- サーバが正本。改造クライアントが `isPremium=true` にしても、`/iap/entitlement` 同期で覆る（プレミアム機能をサーバ権利に依存させる度合いは要検討＝現状ローカル機能のみなので効果は「表示の正直さ」中心）。
- Apple 通知は **JWS 署名必須検証**（未検証の通知を信用しない）。
- `/iap/verify` は `X-App-Token` + レート制限（設計2）。

## 段階導入（推奨）

- **Phase 1（MVP）**: `appAccountToken` + `/iap/verify`（オンデマンド検証）+ D1 保存 + 起動時 `/iap/entitlement`。通知はまだ。
- **Phase 2**: App Store Server Notifications V2 受信 → 更新/失効/返金の自動反映。
- **Phase 3**: Android（Play Developer API + RTDN）。

## 必要な設定 / シークレット（あなたの作業）

- App Store Connect: In-App Purchase 用 API キー（Key ID / Issuer / .p8）→ Worker secret。
- App Store Connect: Server Notifications V2 の URL 登録（本番+サンドボックス）。
- Cloudflare: D1 作成（`wrangler d1 create doppel-iap`）+ `wrangler.toml` バインド、`ASC_IAP_KEY_ID` 等の secret。
- （Android）GCP サービスアカウント + Pub/Sub トピック/購読。

---

# 設計2: Worker レート制限（S1強化）

## 目的 / 脅威
`X-App-Token` はアプリに埋め込まれ抽出されうる。抽出者が `/v1/*` を大量に叩くと **OpenAI 課金が膨らむ**。トークン単位・IP単位で制限し、日次コスト上限も設ける。

## 方式比較

| 方式 | 精度 | コスト/手間 | 備考 |
|---|---|---|---|
| **Workers Rate Limiting binding** | 中〜高 | 低（設定のみ） | 推奨・第一防衛。`env.LIMITER.limit({key})` |
| WAF / Rate Limiting Rules（ネットワーク層） | 中 | 低（ダッシュボード） | IP単位の粗い制限。併用推奨 |
| KV カウンタ | 低（結果整合） | 低 | **日次コスト上限**に最適（TTL付き加算） |
| Durable Objects | 高（強整合） | 中 | 厳密なトークンバケットが必要なときのみ |

**推奨構成 = Rate Limiting binding（分単位）＋ WAF ルール（IP粗制限）＋ KV（日次上限）**。DO は現段階では過剰。

## 設計

`wrangler.toml`:
```toml
[[ratelimit]]
name = "AI_LIMITER"
namespace_id = "1001"
simple = { limit = 60, period = 60 }   # 60 req / 60s / key
```
Worker ロジック（`/v1/*` と `/iap/verify` に適用）:
```
key = X-App-Token があればそのハッシュ、無ければ CF-Connecting-IP
const { success } = await env.AI_LIMITER.limit({ key })
if (!success) return 429 { error: 'rate_limited' } (+ Retry-After: 60)

# 日次コスト上限（KV）
const dayKey = `cap:${key}:${yyy-mm-dd}`
count = (await env.CAP.get(dayKey)) ?? 0
if (count >= DAILY_MAX) return 429 { error: 'daily_cap' }
await env.CAP.put(dayKey, count+1, { expirationTtl: 86400 })
```
- アルゴリズム: 分制限は binding（スライディング相当）、日次は KV 固定窓。
- レスポンス: `429` + `Retry-After`。ボディ `{"error":"rate_limited"}`。

## クライアント側の扱い
- `AiBackendConfig` 経由の呼び出しで **429 を「クラウド一時失敗」として扱う** → 既存のフォールバック（ローカル/簡易採点）に落とす。フィードバック画面は S3 の「簡易採点」注記でユーザーに伝わる。
- 連続 429 時は指数バックオフ（任意）。

## 観測性
- `console.log` で `{key(ハッシュ), path, limited}` を出し `wrangler tail` / Workers Analytics で監視。
- しきい値（60/min, 日次上限）は運用しながら調整可能な定数に。

## 必要な設定
- Cloudflare: Rate Limiting binding 有効化、KV namespace 作成（`wrangler kv namespace create CAP`）+ バインド。
- （任意）WAF: ルート `doppel-ai-proxy.*.workers.dev` に IP レート制限ルール。

---

## 未決定事項（あなたの判断）

1. **Android を今スコープに含めるか**（含めないなら iOS のみで Phase 1→2 を先行）。
2. **通知を Phase 1 から入れるか**（オンデマンド検証だけで開始 → 後で通知追加、を推奨）。
3. **ストレージ**: D1 推奨（逆引き索引が要るため）。KV のみに寄せたい理由があるか。
4. **プレミアム機能の性質**: 現状プレミアム=「回数無制限」だけでサーバ機能ではないため、サーバ検証の主目的は「正直さ/返金反映」。将来サーバ側の有料機能を足すなら検証の重要度が上がる。

## 工数感（目安）

| フェーズ | 内容 | 目安 |
|---|---|---|
| RL | Rate limiting binding + KV 日次上限 + 429ハンドリング | 小 |
| IAP P1 | appAccountToken + /iap/verify + D1 + 起動同期 | 中 |
| IAP P2 | ASSN V2 受信 + JWS検証 | 中〜大 |
| IAP P3 | Android（Play API + RTDN） | 中〜大 |

推奨着手順: **レート制限（小・即効・コスト防御）→ IAP Phase 1 → Phase 2**。
