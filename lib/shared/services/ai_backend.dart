/// Resolves how the app reaches OpenAI-compatible endpoints.
///
/// Two modes, chosen at build time via `--dart-define`:
///
/// * **Proxy mode** (recommended for release): set `AI_PROXY_URL` to a backend
///   that holds the real OpenAI key and forwards `/v1/*` requests (see
///   `server/cloudflare-worker`). The app then embeds **no** OpenAI key; it
///   only sends an optional `AI_PROXY_TOKEN` as `X-App-Token`.
/// * **Direct mode** (dev only): set `OPENAI_API_KEY` and the app calls OpenAI
///   directly with a bearer token. Convenient locally, but the key is
///   extractable from the binary — do not ship this.
///
/// If neither is set, [isAvailable] is false and callers fall back to
/// local/simulated results.
class AiBackendConfig {
  AiBackendConfig({String? apiKey, String? proxyUrl, String? proxyToken})
      : apiKey = apiKey ?? const String.fromEnvironment('OPENAI_API_KEY'),
        proxyUrl = proxyUrl ?? const String.fromEnvironment('AI_PROXY_URL'),
        proxyToken =
            proxyToken ?? const String.fromEnvironment('AI_PROXY_TOKEN');

  /// OpenAI API key (direct mode only). Empty in proxy mode.
  final String apiKey;

  /// Base URL of the proxy, e.g. `https://doppel-ai-proxy.example.workers.dev`
  /// (no trailing slash, no `/v1`). Empty means direct mode.
  final String proxyUrl;

  /// Optional shared token the proxy checks (sent as `X-App-Token`).
  final String proxyToken;

  bool get usesProxy => proxyUrl.isNotEmpty;

  /// Cloud is reachable if a proxy is configured (key held server-side) or a
  /// direct key is present.
  bool get isAvailable => usesProxy || apiKey.isNotEmpty;

  String get _base =>
      proxyUrl.endsWith('/') ? proxyUrl.substring(0, proxyUrl.length - 1) : proxyUrl;

  String get chatUrl => usesProxy
      ? '$_base/v1/chat/completions'
      : 'https://api.openai.com/v1/chat/completions';

  String get transcriptionUrl => usesProxy
      ? '$_base/v1/audio/transcriptions'
      : 'https://api.openai.com/v1/audio/transcriptions';

  /// Auth headers for a request: in direct mode an OpenAI bearer token; in
  /// proxy mode the optional app token (the OpenAI key lives on the server).
  Map<String, String> authHeaders() {
    if (usesProxy) {
      return proxyToken.isEmpty ? const {} : {'X-App-Token': proxyToken};
    }
    return {'Authorization': 'Bearer $apiKey'};
  }
}
