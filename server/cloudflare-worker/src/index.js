/**
 * Doppel AI proxy + IAP receipt validation (Cloudflare Worker).
 *
 * Endpoints (all require X-App-Token when APP_TOKEN is set; all rate-limited):
 *   POST /v1/chat/completions        → OpenAI proxy (key injected server-side)
 *   POST /v1/audio/transcriptions    → OpenAI proxy (Whisper)
 *   POST /iap/verify                 → validate an App Store receipt, store entitlement
 *   GET  /iap/entitlement            → read stored entitlement (X-App-Account-Token header)
 *   POST /progress/sync              → back up anonymous progress (body: appAccountToken, data, updatedAt)
 *   GET  /progress                   → read backed-up progress (X-App-Account-Token header)
 *   DELETE /progress                 → erase backed-up progress (X-App-Account-Token header)
 *
 * Secrets (set with `wrangler secret put`, never committed):
 *   OPENAI_API_KEY       – the real OpenAI key (required for the proxy)
 *   APP_TOKEN            – optional shared token the app sends as `X-App-Token`
 *   APPLE_SHARED_SECRET  – App Store app-specific shared secret (for /iap/*)
 *
 * Optional bindings (see wrangler.toml):
 *   RL (KV)  – per-IP requests/minute + global requests/day cap.
 *   DB (D1)  – entitlements store for /iap/* and progress store for /progress*.
 *              Without it, those routes return 500.
 *
 * NOTE: /iap/verify uses Apple's `verifyReceipt` (deprecated but functional and
 * simple). Phase 2 migrates to the App Store Server API + Server Notifications.
 */

const OPENAI_BASE = 'https://api.openai.com';
const PREMIUM_PRODUCT_ID = 'com.ishtos.doppel.premium.monthly';

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

// Progress snapshots are tiny; cap the body so the blob store can't be abused.
const MAX_PROGRESS_BYTES = 64 * 1024;

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    const isProxy = ALLOWED_PATHS.has(path);
    const isVerify = path === '/iap/verify';
    const isEntitlement = path === '/iap/entitlement';
    const isProgressSync = path === '/progress/sync';
    const isProgress = path === '/progress'; // GET (read) or DELETE (erase)
    if (!isProxy && !isVerify && !isEntitlement && !isProgressSync && !isProgress) {
      return json({ error: 'not_found' }, 404);
    }

    // Method per route.
    const method = request.method;
    const methodOk = isEntitlement
        ? method === 'GET'
        : isProgress
            ? method === 'GET' || method === 'DELETE'
            : method === 'POST'; // proxy, verify, progress/sync
    if (!methodOk) return json({ error: 'method_not_allowed' }, 405);

    // Shared token gate so nothing here is an open relay.
    if (env.APP_TOKEN && request.headers.get('X-App-Token') !== env.APP_TOKEN) {
      return json({ error: 'unauthorized' }, 401);
    }

    // Per-IP rate limiting for all routes; the daily *cost* cap only bounds the
    // OpenAI proxy, so backup/entitlement traffic can't 429 the scoring path.
    const limited = await enforceLimits(request, env, { countCost: isProxy });
    if (limited) return limited;

    try {
      if (isProxy) return await handleProxy(request, env, path);
      if (isVerify) return await handleIapVerify(request, env);
      if (isEntitlement) return await handleIapEntitlement(request, env);
      if (isProgressSync) return await handleProgressSync(request, env);
      if (method === 'DELETE') return await handleProgressDelete(request, env);
      return await handleProgressGet(request, env);
    } catch (_) {
      // Unexpected failure (e.g. a D1 write error). Return JSON with a retriable
      // status so the client re-tries safely (all writes here are idempotent).
      return json({ error: 'internal_error' }, 503);
    }
  },
};

// ── Rate limiting (KV, optional) ──

async function enforceLimits(request, env, { countCost = true } = {}) {
  if (!env.RL) return null;
  const minute = new Date().toISOString().slice(0, 16); // YYYY-MM-DDTHH:MM
  const ip = request.headers.get('CF-Connecting-IP') || 'unknown';

  // Per-IP request rate applies to every route.
  const ipKey = `ip:${ip}:${minute}`;
  const ipCount = parseInt((await env.RL.get(ipKey)) || '0', 10);
  if (ipCount >= PER_IP_PER_MINUTE) {
    return json({ error: 'rate_limited' }, 429, { 'Retry-After': '60' });
  }
  await env.RL.put(ipKey, String(ipCount + 1), { expirationTtl: 120 });

  // Global daily cost cap bounds OpenAI spend — enforce it only for the proxy
  // routes that actually cost money, so backup/entitlement traffic is exempt.
  if (countCost) {
    const capKey = `cap:${minute.slice(0, 10)}`; // cap:YYYY-MM-DD
    const dayCount = parseInt((await env.RL.get(capKey)) || '0', 10);
    if (dayCount >= DAILY_MAX) {
      return json({ error: 'daily_cap' }, 429, { 'Retry-After': '3600' });
    }
    await env.RL.put(capKey, String(dayCount + 1), { expirationTtl: 172800 });
  }
  return null;
}

// ── OpenAI proxy ──

async function handleProxy(request, env, path) {
  if (!env.OPENAI_API_KEY) {
    return json({ error: 'server_misconfigured' }, 500);
  }

  const body = await request.arrayBuffer();
  if (body.byteLength > MAX_BODY_BYTES) {
    return json({ error: 'payload_too_large' }, 413);
  }

  // Forward to OpenAI, injecting the real key. Preserve Content-Type so the
  // multipart boundary (Whisper) and JSON type (chat) survive.
  const headers = new Headers();
  const contentType = request.headers.get('Content-Type');
  if (contentType) headers.set('Content-Type', contentType);
  headers.set('Authorization', `Bearer ${env.OPENAI_API_KEY}`);

  let upstream;
  try {
    upstream = await fetch(`${OPENAI_BASE}${path}`, {
      method: 'POST',
      headers,
      body,
    });
  } catch (_) {
    return json({ error: 'upstream_unreachable' }, 502);
  }

  const respHeaders = new Headers(upstream.headers);
  respHeaders.delete('Set-Cookie');
  return new Response(upstream.body, {
    status: upstream.status,
    headers: respHeaders,
  });
}

// ── IAP: receipt validation (Apple) ──

async function handleIapVerify(request, env) {
  if (!env.DB || !env.APPLE_SHARED_SECRET) {
    return json({ error: 'iap_unconfigured' }, 500);
  }

  let body;
  try {
    body = await request.json();
  } catch (_) {
    return json({ error: 'bad_request' }, 400);
  }
  const appAccountToken = body && body.appAccountToken;
  const receipt = body && body.receipt;
  if (!appAccountToken || !receipt) {
    return json({ error: 'bad_request' }, 400);
  }

  const result = await verifyAppleReceipt(receipt, env.APPLE_SHARED_SECRET);
  if (!result.ok) {
    return json({ error: 'invalid_receipt' }, 400);
  }

  // One subscription (original_transaction_id) entitles one install: expire any
  // other token that previously claimed this receipt (blocks receipt sharing).
  // Uses the idx_entitlements_otid index.
  if (result.originalTransactionId) {
    await env.DB.prepare(
      `UPDATE entitlements SET status = 'expired', updated_at = ?
       WHERE original_transaction_id = ? AND app_account_token != ?`,
    ).bind(Date.now(), result.originalTransactionId, appAccountToken).run();
  }

  await upsertEntitlement(env.DB, {
    appAccountToken,
    originalTransactionId: result.originalTransactionId || null,
    productId: result.productId || PREMIUM_PRODUCT_ID,
    entitled: result.entitled,
    expiresDateMs: result.expiresDateMs || null,
    environment: result.environment || 'Production',
  });

  return json(entitlementResponse(result.entitled, result.productId, result.expiresDateMs, result.environment), 200);
}

async function handleIapEntitlement(request, env) {
  if (!env.DB) return json({ error: 'iap_unconfigured' }, 500);
  const token = accountToken(request);
  if (!token) return json({ error: 'bad_request' }, 400);

  const row = await env.DB.prepare(
    'SELECT product_id, status, expires_date, environment FROM entitlements WHERE app_account_token = ?',
  ).bind(token).first();

  if (!row) return json({ entitled: false }, 200);
  const entitled = row.status === 'active' &&
    (row.expires_date == null || row.expires_date > Date.now());
  return json(entitlementResponse(entitled, row.product_id, row.expires_date, row.environment), 200);
}

// ── Progress backup (anonymous, keyed by per-install token) ──
//
// The server is a dumb per-token blob store: it keeps the last synced snapshot
// and its client timestamp. Conflict resolution (a progress-preferring merge)
// lives on the client, which merges the stored snapshot into local state on
// restore before syncing back. No account/login — the token is the only key.

async function handleProgressSync(request, env) {
  if (!env.DB) return json({ error: 'progress_unconfigured' }, 500);

  // Size-check before parsing (read as text so we can bound it).
  const raw = await request.text();
  if (raw.length > MAX_PROGRESS_BYTES) {
    return json({ error: 'payload_too_large' }, 413);
  }
  let body;
  try {
    body = JSON.parse(raw);
  } catch (_) {
    return json({ error: 'bad_request' }, 400);
  }
  const appAccountToken = body && body.appAccountToken;
  const data = body && body.data;
  if (!appAccountToken || !validateProgress(data)) {
    return json({ error: 'bad_request' }, 400);
  }
  const updatedAt =
    typeof body.updatedAt === 'number' && Number.isFinite(body.updatedAt)
      ? body.updatedAt
      : Date.now();

  // Reject stale writes: only overwrite when this snapshot is newer than the
  // stored one, so an out-of-order or concurrent packet can't roll progress
  // back. First insert (no conflict) always applies.
  await env.DB.prepare(
    `INSERT INTO progress (app_account_token, data, updated_at)
     VALUES (?, ?, ?)
     ON CONFLICT(app_account_token) DO UPDATE SET
       data = excluded.data,
       updated_at = excluded.updated_at
     WHERE excluded.updated_at > progress.updated_at`,
  ).bind(appAccountToken, JSON.stringify(data), updatedAt).run();

  return json({ ok: true, updatedAt }, 200);
}

async function handleProgressGet(request, env) {
  if (!env.DB) return json({ error: 'progress_unconfigured' }, 500);
  const token = accountToken(request);
  if (!token) return json({ error: 'bad_request' }, 400);

  const row = await env.DB.prepare(
    'SELECT data, updated_at FROM progress WHERE app_account_token = ?',
  ).bind(token).first();

  if (!row) return json({ data: null, updatedAt: null }, 200);
  let data;
  try {
    data = JSON.parse(row.data);
  } catch (_) {
    data = null;
  }
  return json({ data, updatedAt: row.updated_at }, 200);
}

// Erase a user's backed-up progress (GDPR "right to erasure" / user reset).
async function handleProgressDelete(request, env) {
  if (!env.DB) return json({ error: 'progress_unconfigured' }, 500);
  const token = accountToken(request);
  if (!token) return json({ error: 'bad_request' }, 400);
  await env.DB.prepare('DELETE FROM progress WHERE app_account_token = ?')
      .bind(token)
      .run();
  return json({ ok: true }, 200);
}

/**
 * Validate an App Store receipt via Apple's verifyReceipt. Tries production
 * first, then sandbox on status 21007. Returns the latest expiry for our
 * product.
 */
async function verifyAppleReceipt(receipt, sharedSecret) {
  const payload = JSON.stringify({
    'receipt-data': receipt,
    'password': sharedSecret,
    'exclude-old-transactions': true,
  });

  let data = await callVerifyReceipt('https://buy.itunes.apple.com/verifyReceipt', payload);
  if (data && data.status === 21007) {
    data = await callVerifyReceipt('https://sandbox.itunes.apple.com/verifyReceipt', payload);
  }
  if (!data || data.status !== 0) return { ok: false };

  const environment = data.environment || 'Production';
  const infos = data.latest_receipt_info || [];
  let best = null;
  for (const info of infos) {
    if (info.product_id !== PREMIUM_PRODUCT_ID) continue;
    const exp = parseInt(info.expires_date_ms || '0', 10);
    if (!best || exp > best.exp) {
      best = { exp, originalTransactionId: info.original_transaction_id };
    }
  }

  if (!best) {
    return { ok: true, entitled: false, productId: PREMIUM_PRODUCT_ID, environment };
  }
  return {
    ok: true,
    entitled: best.exp > Date.now(),
    productId: PREMIUM_PRODUCT_ID,
    expiresDateMs: best.exp,
    environment,
    originalTransactionId: best.originalTransactionId,
  };
}

async function callVerifyReceipt(endpoint, payload) {
  try {
    const resp = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: payload,
    });
    if (!resp.ok) return null;
    return await resp.json();
  } catch (_) {
    return null;
  }
}

async function upsertEntitlement(db, e) {
  const status = e.entitled ? 'active' : 'expired';
  await db.prepare(
    `INSERT INTO entitlements
       (app_account_token, platform, original_transaction_id, product_id, status, expires_date, environment, updated_at)
     VALUES (?, 'apple', ?, ?, ?, ?, ?, ?)
     ON CONFLICT(app_account_token) DO UPDATE SET
       original_transaction_id = excluded.original_transaction_id,
       product_id = excluded.product_id,
       status = excluded.status,
       expires_date = excluded.expires_date,
       environment = excluded.environment,
       updated_at = excluded.updated_at`,
  ).bind(
    e.appAccountToken,
    e.originalTransactionId,
    e.productId,
    status,
    e.expiresDateMs,
    e.environment,
    Date.now(),
  ).run();
}

// ── Helpers ──

// The per-install token is a credential, not a public id — read it from a
// header, never a URL query string (which lands in access logs).
function accountToken(request) {
  return request.headers.get('X-App-Account-Token');
}

// Whitelist-validate a progress snapshot to the known UserProgress shape, so the
// blob store can't be used to persist arbitrary or oversized data. Exported for
// unit testing.
export function validateProgress(data) {
  if (data == null || typeof data !== 'object' || Array.isArray(data)) {
    return false;
  }
  const counters = [
    'currentStreak',
    'longestStreak',
    'totalPracticeMinutes',
    'completedLessons',
  ];
  for (const k of counters) {
    const v = data[k];
    if (typeof v !== 'number' || !Number.isInteger(v) || v < 0 || v > 1e9) {
      return false;
    }
  }
  if (typeof data.userId !== 'string' || data.userId.length > 128) return false;
  if (typeof data.lastPracticeDate !== 'string' ||
      data.lastPracticeDate.length > 40) {
    return false;
  }
  return true;
}

function entitlementResponse(entitled, productId, expiresDateMs, environment) {
  return {
    entitled: !!entitled,
    productId: productId || null,
    expiresDate: expiresDateMs ? new Date(expiresDateMs).toISOString() : null,
    environment: environment || null,
  };
}

function json(obj, status, extraHeaders) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...(extraHeaders || {}) },
  });
}
