import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import 'analytics_service.dart';

/// The concrete backend. [NoopAnalytics] today — no data leaves the device.
/// When a PostHog project key is available this is the single line to change
/// (return a PostHogAnalytics), and every call site keeps working unchanged.
final analyticsBackendProvider = Provider<AnalyticsService>((ref) {
  // TODO(analytics): return PostHogAnalytics(apiKey: ...) once configured.
  return const NoopAnalytics();
});

/// App-wide analytics sink. Wrapped in a consent gate so nothing is captured
/// unless the user has opted into cloud analysis (`cloudAnalysisConsent`),
/// matching how the app already gates sending data to the cloud.
final analyticsProvider = Provider<AnalyticsService>((ref) {
  final backend = ref.watch(analyticsBackendProvider);
  return ConsentGatedAnalytics(
    backend,
    () => ref.read(settingsProvider).cloudAnalysisConsent,
  );
});
