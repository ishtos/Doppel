import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/services/speech_analysis_service.dart';

// Scoring should only cover the part the user actually read. coveredModelSpan
// trims the model transcript to the read (sequential) portion so unread
// trailing text does not lower the score.
void main() {
  group('coveredModelSpan', () {
    const model =
        'Good morning everyone. Today we start with the news. The weather is clear.';

    test('trims to the read portion when the user stops early', () {
      final span =
          SpeechAnalysisService.coveredModelSpan(model, 'good morning everyone');
      expect(span, 'Good morning everyone.');
    });

    test('keeps the whole model when the user reaches (near) the end', () {
      final span = SpeechAnalysisService.coveredModelSpan(
        model,
        'good morning everyone today we start with the news the weather is clear',
      );
      expect(span, model);
    });

    test('returns the full model when nothing aligns', () {
      expect(SpeechAnalysisService.coveredModelSpan(model, 'zzz qqq'), model);
    });

    test('empty user transcript returns the full model', () {
      expect(SpeechAnalysisService.coveredModelSpan(model, ''), model);
    });
  });
}
