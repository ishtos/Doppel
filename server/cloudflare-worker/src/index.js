/**
 * Doppel AI proxy — a Cloudflare Worker that hides the OpenAI API key.
 *
 * The mobile app is built with `--dart-define=AI_PROXY_URL=<this worker URL>`
 * (and no OPENAI_API_KEY), so the key never ships inside the app binary. The
 * Worker forwards a small allow-list of `/v1/*` POST endpoints to OpenAI,
 * injecting the real key server-side.
 *
 * Secrets (set with `wrangler secret put`, never committed):
 *   OPENAI_API_KEY  – the real OpenAI key (required)
 *   APP_TOKEN       – optional shared token the app sends as `X-App-Token`.
 *                     When set, requests without a matching token are rejected,
 *                     which keeps the proxy from being an open relay.
 *
 * Optional abuse/cost control (see wrangler.toml):
 *   RL (KV namespace) – enables a per-IP requests/minute limit and a global
 *                       requests/day ceiling. If the binding is absent the
 *                       proxy still works, just without limiting.
 */

const OPENAI_BASE = 'https://api.openai.com';

// Only these upstream paths may be proxied.
const ALLOWED_PATHS = new Set([
  '/v1/chat/completions',
  '/v1/audio/transcriptions',
]);

// Reject oversized bodies (audio clips are small; this caps abuse). 25 MB.
const MAX_BODY_BYTES = 25 * 1024 * 1024;

// Abuse/cost limits (enforced only when the RL KV namespace is bound). The
// shared APP_TOKEN can't distinguish users, so the per-request limit is keyed
// on client IP; the daily cap is global and bounds total OpenAI spend. Tune to
// your budget.
const PER_IP_PER_MINUTE = 60;
const DAILY_MAX = 5000;

export default {
  async fetch(request, env) {
    if (request.method !== 'POST') {
      return json({ error: 'method_not_allowed' }, 405);
    }

    const url = new URL(request.url);
    if (!ALLOWED_PATHS.has(url.pathname)) {
      return json({ error: 'not_found' }, 404);
    }

    // Optional shared-token gate so the proxy isn't an open relay.
    if (env.APP_TOKEN && request.headers.get('X-App-Token') !== env.APP_TOKEN) {
      return json({ error: 'unauthorized' }, 401);
    }

    // Optional rate limiting + daily cost cap (KV-backed). KV is eventually
    // consistent, so counts are approximate — fine for coarse abuse control.
    if (env.RL) {
      const minute = new Date().toISOString().slice(0, 16); // YYYY-MM-DDTHH:MM
      const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
      const ipKey = `ip:${ip}:${minute}`;
      const ipCount = parseInt((await env.RL.get(ipKey)) || '0', 10);
      if (ipCount >= PER_IP_PER_MINUTE) {
        return json({ error: 'rate_limited' }, 429, { 'Retry-After': '60' });
      }

      const capKey = `cap:${minute.slice(0, 10)}`; // cap:YYYY-MM-DD
      const dayCount = parseInt((await env.RL.get(capKey)) || '0', 10);
      if (dayCount >= DAILY_MAX) {
        return json({ error: 'daily_cap' }, 429, { 'Retry-After': '3600' });
      }

      // Best-effort increments; short TTLs let the keys self-expire.
      await env.RL.put(ipKey, String(ipCount + 1), { expirationTtl: 120 });
      await env.RL.put(capKey, String(dayCount + 1), { expirationTtl: 172800 });
    }

    if (!env.OPENAI_API_KEY) {
      return json({ error: 'server_misconfigured' }, 500);
    }

    const body = await request.arrayBuffer();
    if (body.byteLength > MAX_BODY_BYTES) {
      return json({ error: 'payload_too_large' }, 413);
    }

    // Forward to OpenAI, injecting the real key. Preserve Content-Type so the
    // multipart boundary (for Whisper) and JSON type (for chat) survive.
    const headers = new Headers();
    const contentType = request.headers.get('Content-Type');
    if (contentType) headers.set('Content-Type', contentType);
    headers.set('Authorization', `Bearer ${env.OPENAI_API_KEY}`);

    let upstream;
    try {
      upstream = await fetch(`${OPENAI_BASE}${url.pathname}`, {
        method: 'POST',
        headers,
        body,
      });
    } catch (_) {
      return json({ error: 'upstream_unreachable' }, 502);
    }

    // Pass the response through untouched (minus hop-by-hop headers).
    const respHeaders = new Headers(upstream.headers);
    respHeaders.delete('Set-Cookie');
    return new Response(upstream.body, {
      status: upstream.status,
      headers: respHeaders,
    });
  },
};

function json(obj, status, extraHeaders) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...(extraHeaders || {}) },
  });
}
