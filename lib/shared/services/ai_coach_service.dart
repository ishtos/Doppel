import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'ai_backend.dart';

final aiCoachServiceProvider = Provider<AiCoachService>((ref) {
  return AiCoachService();
});

/// Result of an AI coach generation: the message plus whether it is a local
/// fallback because a cloud call was attempted and failed (distinct from being
/// local by design when cloud analysis is off).
class CoachMessage {
  const CoachMessage(this.text, {this.isFallback = false});

  final String text;
  final bool isFallback;
}

class AiCoachService {
  AiCoachService({AiBackendConfig? backend, http.Client? httpClient})
      : _backend = backend ?? AiBackendConfig(),
        _client = httpClient ?? http.Client();

  final AiBackendConfig _backend;
  final http.Client _client;

  /// Whether a cloud backend (proxy or direct key) is configured.
  bool get isCloudAvailable => _backend.isAvailable;

  /// Generate a coach message. [CoachMessage.isFallback] is true only when a
  /// cloud call was attempted but failed — not when cloud is off by design.
  Future<CoachMessage> generateFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
    bool cloudEnabled = false,
  }) async {
    String local() => _localFeedback(
          pronunciationScore: pronunciationScore,
          rhythmScore: rhythmScore,
          intonationScore: intonationScore,
          problemWords: problemWords,
        );

    if (!isCloudAvailable || !cloudEnabled) {
      return CoachMessage(local()); // local by design — not a failure
    }

    try {
      final message = await _callOpenAI(
        '発音スコア: $pronunciationScore/100\n'
        'リズムスコア: $rhythmScore/100\n'
        'イントネーションスコア: $intonationScore/100\n'
        '問題のある単語: ${problemWords.join(", ")}\n',
      );
      return CoachMessage(message);
    } catch (_) {
      return CoachMessage(local(), isFallback: true); // cloud failed → surface
    }
  }

  /// Regenerate feedback via API. Throws on failure (no fallback).
  /// Used by retry UI so users know if the request actually failed.
  Future<String> regenerateFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
    bool cloudEnabled = false,
  }) async {
    if (!isCloudAvailable || !cloudEnabled) {
      // No API key or no cloud consent → return local feedback, don't throw.
      return _localFeedback(
        pronunciationScore: pronunciationScore,
        rhythmScore: rhythmScore,
        intonationScore: intonationScore,
        problemWords: problemWords,
      );
    }

    return await _callOpenAI(
      '発音スコア: $pronunciationScore/100\n'
      'リズムスコア: $rhythmScore/100\n'
      'イントネーションスコア: $intonationScore/100\n'
      '問題のある単語: ${problemWords.join(", ")}\n',
    );
  }

  /// Generate weekly review message.
  Future<String> generateWeeklyReview({
    required int averageScore,
    required int practiceCount,
    required List<String> weakPatterns,
    bool cloudEnabled = false,
  }) async {
    if (!isCloudAvailable || !cloudEnabled) {
      return _localWeeklyReview(
        averageScore: averageScore,
        practiceCount: practiceCount,
      );
    }

    try {
      return await _callOpenAI(
        '今週の練習回数: $practiceCount回\n'
        '平均スコア: $averageScore/100\n'
        '苦手パターン: ${weakPatterns.join(", ")}\n',
      );
    } catch (_) {
      return _localWeeklyReview(
        averageScore: averageScore,
        practiceCount: practiceCount,
      );
    }
  }

  Future<String> _callOpenAI(String prompt) async {
    final response = await _client.post(
      Uri.parse(_backend.chatUrl),
      headers: {
        'Content-Type': 'application/json',
        ..._backend.authHeaders(),
      },
      body: jsonEncode({
        'model': 'gpt-5-mini',
        // GPT-5 models reject `max_tokens` (400 unsupported_parameter) and
        // require `max_completion_tokens`. Keep headroom above the 2-3 sentence
        // reply, and use minimal reasoning — this is a short templated message,
        // so deep reasoning would only burn the token budget (risking empty
        // output) and add latency/cost.
        'max_completion_tokens': 512,
        'reasoning_effort': 'minimal',
        'messages': [
          {
            'role': 'system',
            'content': 'あなたは英語シャドーイングのAIコーチです。'
                '具体的で励みになるフィードバックを日本語で提供してください。'
                '2-3文で簡潔に。',
          },
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List;
      final message = choices.first['message'] as Map<String, dynamic>;
      return message['content'] as String;
    }

    throw Exception('OpenAI API error: ${response.statusCode}');
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
