import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final aiCoachServiceProvider = Provider<AiCoachService>((ref) {
  return AiCoachService();
});

class AiCoachService {
  static const _apiKeyPref = 'claude_api_key';
  static const _baseUrl = 'https://api.anthropic.com/v1/messages';

  String? _apiKey;

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, key);
  }

  Future<String?> _getApiKey() async {
    if (_apiKey != null) return _apiKey;
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString(_apiKeyPref);
    return _apiKey;
  }

  bool get hasApiKey => _apiKey != null;

  /// Generate feedback message using Claude API.
  /// Falls back to local template if API key is not configured.
  Future<String> generateFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
  }) async {
    final apiKey = await _getApiKey();
    if (apiKey == null) {
      return _localFeedback(
        pronunciationScore: pronunciationScore,
        rhythmScore: rhythmScore,
        intonationScore: intonationScore,
        problemWords: problemWords,
      );
    }

    try {
      return await _callClaude(
        'あなたは英語シャドーイングのAIコーチです。'
        'ユーザーの練習結果を分析し、具体的で励みになるフィードバックを日本語で提供してください。'
        '2-3文で簡潔に。\n\n'
        '発音スコア: $pronunciationScore/100\n'
        'リズムスコア: $rhythmScore/100\n'
        'イントネーションスコア: $intonationScore/100\n'
        '問題のある単語: ${problemWords.join(", ")}\n',
        apiKey: apiKey,
      );
    } catch (_) {
      return _localFeedback(
        pronunciationScore: pronunciationScore,
        rhythmScore: rhythmScore,
        intonationScore: intonationScore,
        problemWords: problemWords,
      );
    }
  }

  /// Generate weekly review message.
  Future<String> generateWeeklyReview({
    required int averageScore,
    required int practiceCount,
    required List<String> weakPatterns,
  }) async {
    final apiKey = await _getApiKey();
    if (apiKey == null) {
      return _localWeeklyReview(
        averageScore: averageScore,
        practiceCount: practiceCount,
      );
    }

    try {
      return await _callClaude(
        'あなたは英語シャドーイングのAIコーチです。'
        'ユーザーの週間成績をレビューし、モチベーションを高めるコメントを日本語で提供してください。'
        '2-3文で簡潔に。\n\n'
        '今週の練習回数: $practiceCount回\n'
        '平均スコア: $averageScore/100\n'
        '苦手パターン: ${weakPatterns.join(", ")}\n',
        apiKey: apiKey,
      );
    } catch (_) {
      return _localWeeklyReview(
        averageScore: averageScore,
        practiceCount: practiceCount,
      );
    }
  }

  Future<String> _callClaude(String prompt, {required String apiKey}) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-haiku-4-5-20251001',
        'max_tokens': 256,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['content'] as List;
      return content.first['text'] as String;
    }

    throw Exception('Claude API error: ${response.statusCode}');
  }

  // ── Local fallback templates ──

  String _localFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
  }) {
    final avg = ((pronunciationScore + rhythmScore + intonationScore) / 3).round();

    final buffer = StringBuffer();

    if (avg >= 80) {
      buffer.write('素晴らしい練習でした！');
    } else if (avg >= 60) {
      buffer.write('良い調子です！');
    } else {
      buffer.write('練習を続けましょう！');
    }

    // Find weakest area
    final scores = {
      '発音': pronunciationScore,
      'リズム': rhythmScore,
      'イントネーション': intonationScore,
    };
    final weakest = scores.entries.reduce((a, b) => a.value < b.value ? a : b);

    buffer.write(' ${weakest.key}の改善がスコアアップの鍵です。');

    if (problemWords.isNotEmpty) {
      buffer.write(
        ' 特に「${problemWords.take(2).join("」「")}」の発音に注意しましょう。',
      );
    }

    return buffer.toString();
  }

  String _localWeeklyReview({
    required int averageScore,
    required int practiceCount,
  }) {
    if (practiceCount == 0) {
      return 'レッスンを始めると、AIコーチが毎週あなたの進捗をレビューします。';
    }

    final buffer = StringBuffer();
    buffer.write('今週は$practiceCount回練習しました。');

    if (averageScore >= 80) {
      buffer.write('平均$averageScore点と好成績です。この調子で続けましょう！');
    } else if (averageScore >= 60) {
      buffer.write('平均$averageScore点です。着実に上達しています！');
    } else {
      buffer.write('平均$averageScore点です。毎日少しずつ練習を重ねましょう。');
    }

    return buffer.toString();
  }
}
