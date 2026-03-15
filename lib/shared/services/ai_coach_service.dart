import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final aiCoachServiceProvider = Provider<AiCoachService>((ref) {
  return AiCoachService();
});

class AiCoachService {
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const _apiKey = String.fromEnvironment('OPENAI_API_KEY');

  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Generate feedback message using OpenAI API.
  /// Falls back to local template if API key is not configured.
  Future<String> generateFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
  }) async {
    if (!hasApiKey) {
      return _localFeedback(
        pronunciationScore: pronunciationScore,
        rhythmScore: rhythmScore,
        intonationScore: intonationScore,
        problemWords: problemWords,
      );
    }

    try {
      return await _callOpenAI(
        '発音スコア: $pronunciationScore/100\n'
        'リズムスコア: $rhythmScore/100\n'
        'イントネーションスコア: $intonationScore/100\n'
        '問題のある単語: ${problemWords.join(", ")}\n',
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
    if (!hasApiKey) {
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
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-5-mini',
        'max_tokens': 256,
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
