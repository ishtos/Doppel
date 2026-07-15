-- D1 schema for IAP entitlements (server-authoritative premium).
-- Apply with:
--   wrangler d1 execute doppel-iap --file=schema.sql --remote
-- (add --local for the local dev DB used by `wrangler dev`).

CREATE TABLE IF NOT EXISTS entitlements (
  app_account_token       TEXT PRIMARY KEY,   -- per-install id (client UUID)
  platform                TEXT NOT NULL,       -- 'apple' (Android is Phase 3)
  original_transaction_id TEXT,                -- Apple: restore/dedup key
  product_id              TEXT NOT NULL,
  status                  TEXT NOT NULL,       -- 'active' | 'expired'
  expires_date            INTEGER,             -- epoch ms
  environment             TEXT NOT NULL,       -- 'Production' | 'Sandbox'
  updated_at              INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_entitlements_otid
  ON entitlements(original_transaction_id);

-- Anonymous progress backup (no login). Keyed by the same per-install token.
-- The server is a dumb per-token blob store; the client does the
-- progress-preferring merge on restore. Lets progress survive reinstall /
-- device change without an account.
CREATE TABLE IF NOT EXISTS progress (
  app_account_token TEXT PRIMARY KEY,   -- per-install id (client UUID)
  data              TEXT NOT NULL,       -- JSON snapshot of the user's progress
  updated_at        INTEGER NOT NULL     -- client write time, epoch ms
);
