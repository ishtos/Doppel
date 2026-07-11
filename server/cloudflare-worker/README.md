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
