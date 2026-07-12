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
