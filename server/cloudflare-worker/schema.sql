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
