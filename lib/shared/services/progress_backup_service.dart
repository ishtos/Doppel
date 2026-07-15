import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../features/progress/data/models/user_progress_model.dart';
import 'ai_backend.dart';

final progressBackupServiceProvider = Provider<ProgressBackupService>((ref) {
  return ProgressBackupService(AiBackendConfig());
});

/// A restored backup snapshot: the stored progress and its server timestamp.
class ProgressSnapshot {
  const ProgressSnapshot({required this.progress, this.updatedAt});

  final UserProgressModel progress;
  final DateTime? updatedAt;
}

/// Backs up and restores practice progress anonymously via the backend's
/// `/progress` endpoints, keyed by the per-install token.
///
/// Every method returns null/false when the backend is unconfigured,
/// unreachable, or has nothing stored — callers treat that as "keep local
/// state", so a network error never downgrades a user's progress.
class ProgressBackupService {
  ProgressBackupService(this._config, {http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final AiBackendConfig _config;
  final http.Client _client;

  bool get isAvailable => _config.progressSyncUrl != null;

  /// Fetch the backed-up snapshot for [appAccountToken], or null if
  /// unavailable / unreachable / nothing stored / malformed.
  Future<ProgressSnapshot?> fetch({required String appAccountToken}) async {
    final base = _config.progressGetUrl;
    if (base == null) return null;
    try {
      final uri = Uri.parse(base)
          .replace(queryParameters: {'appAccountToken': appAccountToken});
      final resp = await _client.get(uri, headers: _config.authHeaders());
      if (resp.statusCode != 200) return null;
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = body['data'];
      if (data is! Map) return null; // nothing stored yet
      final progress =
          UserProgressModel.fromJson(Map<String, dynamic>.from(data));
      final ms = body['updatedAt'];
      return ProgressSnapshot(
        progress: progress,
        updatedAt: ms is int ? DateTime.fromMillisecondsSinceEpoch(ms) : null,
      );
    } catch (_) {
      return null;
    }
  }

  /// Upload [progress] for [appAccountToken]. Returns true on success, false if
  /// unavailable / unreachable — the caller keeps local state either way.
  Future<bool> sync({
    required String appAccountToken,
    required UserProgressModel progress,
    DateTime? updatedAt,
  }) async {
    final url = _config.progressSyncUrl;
    if (url == null) return false;
    try {
      final resp = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', ..._config.authHeaders()},
        body: jsonEncode({
          'appAccountToken': appAccountToken,
          'data': progress.toJson(),
          'updatedAt':
              (updatedAt ?? progress.lastPracticeDate).millisecondsSinceEpoch,
        }),
      );
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
