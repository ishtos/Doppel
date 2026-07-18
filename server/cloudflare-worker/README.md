# Doppel AI proxy (Cloudflare Worker)

Hides the OpenAI API key so it is **not embedded in the app binary** (issue S1).
The app is built pointing at this Worker; the Worker holds the key and forwards
a small allow-list of `/v1/*` endpoints to OpenAI.

```
app  ──(X-App-Token)──▶  Worker  ──(Bearer OPENAI_API_KEY)──▶  api.openai.com
                         holds the key
```

Free to run: Cloudflare Workers' free plan allows 100,000 requests/day and does
not sleep. You still pay OpenAI for usage as before — the proxy only hides the
key.

## Deploy

Prereqs: a (free) Cloudflare account and the Wrangler CLI (`npm i -g wrangler`).

```bash
cd server/cloudflare-worker
wrangler login

# Set secrets (never commit these):
wrangler secret put OPENAI_API_KEY      # paste your OpenAI key
wrangler secret put APP_TOKEN           # a long random string you invent

wrangler deploy
```

Deploy prints the Worker URL, e.g. `https://doppel-ai-proxy.<subdomain>.workers.dev`.

## Point the app at it

Build the app with the proxy URL and app token (and **no** OpenAI key):

```bash
flutter build ios --release \
  --dart-define=AI_PROXY_URL=https://doppel-ai-proxy.<subdomain>.workers.dev \
  --dart-define=AI_PROXY_TOKEN=<the APP_TOKEN you set above>
```

In CI these come from GitHub Secrets — see `.github/workflows/deploy-ios.yml`
(`AI_PROXY_URL`, `AI_PROXY_TOKEN`). Once the proxy is configured, stop injecting
`OPENAI_API_KEY` into the build.

## Rate limiting & daily cost cap (optional, recommended)

`APP_TOKEN` is embedded in the app and can be extracted, so add throughput
limits so a leaked token can't run up your OpenAI bill. Enable by creating a KV
namespace and uncommenting the `RL` binding in `wrangler.toml`:

```bash
wrangler kv namespace create RL   # prints an id
# paste the id into wrangler.toml (uncomment the [[kv_namespaces]] block)
wrangler deploy
```

When the `RL` binding is present the Worker enforces:
- **Per-IP limit**: `PER_IP_PER_MINUTE` (default 60) requests / minute / client IP → `429` + `Retry-After: 60`.
- **Global daily cap**: `DAILY_MAX` (default 5000) requests / day total → `429` + `Retry-After: 3600`.

Both constants live at the top of `src/index.js`; tune to your budget. Counts
use KV (eventually consistent), so limits are approximate — fine for coarse
abuse/cost control. Without the binding the proxy runs unlimited (as before).

Notes:
- The app treats `429` like any cloud failure and falls back to local/simulated
  scoring, so users see a graceful degrade (the "簡易採点" notice), not an error.
- The daily cap is global, so a determined attacker could exhaust it and
  degrade service for everyone; per-user limits become possible once IAP adds a
  per-install token (see `claudedocs/design_20260712_iap-validation-and-rate-limiting.md`).
- To test: with a valid `X-App-Token`, send >60 requests in a minute → `429`.

## IAP receipt validation (server-authoritative premium, optional)

Makes premium depend on a **server-verified** App Store receipt instead of the
client's word. Needs a D1 database and Apple's app-specific shared secret.

```bash
cd server/cloudflare-worker
wrangler d1 create doppel-iap                              # prints a database_id
# paste the id into wrangler.toml (uncomment the [[d1_databases]] block)
wrangler d1 execute doppel-iap --file=schema.sql --remote  # create the table
wrangler secret put APPLE_SHARED_SECRET                    # ASC app-specific shared secret
wrangler deploy
```

Endpoints (both require `X-App-Token`):
- `POST /iap/verify` — `{ appAccountToken, receipt }` → validates via Apple
  `verifyReceipt` (production, falling back to sandbox on 21007), stores the
  entitlement in D1, returns `{ entitled, expiresDate, ... }`.
- `GET /iap/entitlement` — the app sends the token in an `X-App-Account-Token`
  header (never a query string), returns the stored entitlement (synced at
  launch).

The app generates a stable `appAccountToken` per install, passes it as the
StoreKit `applicationUserName`, verifies each purchase against `/iap/verify`,
and trusts the server's answer — falling back to an optimistic local grant only
when the backend is unreachable, so a paying user is never blocked.

Notes / limitations (Phase 1):
- Uses Apple's **`verifyReceipt`** — deprecated but functional and simple.
  Phase 2 migrates to the App Store Server API + Server Notifications V2 so
  renewals / expirations / refunds are pushed to the server automatically.
- Without the `DB` binding + `APPLE_SHARED_SECRET`, `/iap/*` returns 500 and the
  app keeps its previous client-side premium behavior.
- iOS only for now (Android = Phase 3).

## Anonymous progress backup (no login)

Lets a user's practice progress survive reinstall / device change without an
account. Reuses the same `DB` (D1) binding and the per-install
`appAccountToken`. Apply the schema (same file as IAP):

```sh
wrangler d1 execute doppel-iap --file=schema.sql --remote  # adds the progress table
```

Endpoints (both require `X-App-Token`):
- `POST /progress/sync` — `{ appAccountToken, data, updatedAt }` → upserts the
  latest snapshot for that token. The body is capped (64 KB) and `data` is
  shape-validated against the known progress fields. The write only applies
  when `updatedAt` is newer than the stored row, so an out-of-order / concurrent
  packet can't roll progress back.
- `GET /progress` — token sent as an `X-App-Account-Token` header; returns
  `{ data, updatedAt }` (or `{ data: null }` if nothing is stored).

The server keeps only the latest per-token snapshot; the progress-preferring
merge across devices is done on the client, which merges the stored snapshot
into local state on restore and syncs the merged result back so the server
converges to the max. Without the `DB` binding, `/progress*` returns 500 and the
app stays fully local. Run `node --test` for the worker unit tests.

## Behavior / safety

- Only `POST /v1/chat/completions` and `POST /v1/audio/transcriptions` are
  proxied; anything else returns 404.
- If `APP_TOKEN` is set, requests without a matching `X-App-Token` get 401
  (prevents the proxy from being an open relay). Rotate it anytime without
  touching your OpenAI key.
- Request bodies over 25 MB are rejected (413).
- The client never sees or ships the OpenAI key.

## Local test

```bash
wrangler dev
# then point the app at http://127.0.0.1:8787 via --dart-define=AI_PROXY_URL
```
