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
 */

const OPENAI_BASE = 'https://api.openai.com';

// Only these upstream paths may be proxied.
const ALLOWED_PATHS = new Set([
  '/v1/chat/completions',
  '/v1/audio/transcriptions',
]);

// Reject oversized bodies (audio clips are small; this caps abuse). 25 MB.
const MAX_BODY_BYTES = 25 * 1024 * 1024;

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

function json(obj, status) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}
