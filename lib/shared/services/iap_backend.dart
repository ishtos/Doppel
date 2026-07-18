import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_backend.dart';

final iapBackendClientProvider = Provider<IapBackendClient>((ref) {
  return IapBackendClient(AiBackendConfig());
});

/// Server's answer about a device's premium entitlement.
class IapEntitlement {
  const IapEntitlement({required this.entitled, this.expiresDate});

  final bool entitled;
  final DateTime? expiresDate;
}

/// Talks to the backend's `/iap/*` endpoints (see server/cloudflare-worker).
/// The backend holds Apple's shared secret + the entitlement DB, so premium is
/// server-authoritative. Methods return null when the backend is not configured
/// or unreachable — callers should treat null as "unknown, keep current state".
class IapBackendClient {
  IapBackendClient(this._config, {http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final AiBackendConfig _config;
  final http.Client _client;

  bool get isAvailable => _config.iapVerifyUrl != null;

  /// Verify a purchase receipt with the backend and return the resulting
  /// entitlement (or null if unavailable/unreachable/invalid).
  Future<IapEntitlement?> verify({
    required String appAccountToken,
    required String receipt,
  }) async {
    final url = _config.iapVerifyUrl;
    if (url == null) return null;
    try {
      final resp = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', ..._config.authHeaders()},
        body: jsonEncode({
          'appAccountToken': appAccountToken,
          'receipt': receipt,
        }),
      );
      if (resp.statusCode != 200) return null;
      return _parse(resp.body);
    } catch (_) {
      return null;
    }
  }

  /// Fetch the current server-side entitlement for this install (or null if
  /// unavailable/unreachable).
  Future<IapEntitlement?> entitlement({required String appAccountToken}) async {
    final base = _config.iapEntitlementUrl;
    if (base == null) return null;
    try {
      final resp = await _client.get(
        Uri.parse(base),
        headers: {
          ..._config.authHeaders(),
          'X-App-Account-Token': appAccountToken,
        },
      );
      if (resp.statusCode != 200) return null;
      return _parse(resp.body);
    } catch (_) {
      return null;
    }
  }

  IapEntitlement? _parse(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      final expStr = data['expiresDate'] as String?;
      return IapEntitlement(
        entitled: data['entitled'] == true,
        expiresDate: expStr != null ? DateTime.tryParse(expStr) : null,
      );
    } catch (_) {
      return null;
    }
  }
}
