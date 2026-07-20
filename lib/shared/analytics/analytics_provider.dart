import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import 'analytics_service.dart';

/// The concrete analytics backend. [NoopAnalytics] today — no data leaves the
/// device. Wiring a real product-analytics backend is a single change here
/// (return its [AnalyticsService] implementation); every call site keeps
/// working unchanged.
final analyticsBackendProvider = Provider<AnalyticsService>((ref) {
  // TODO(analytics): return a real AnalyticsService backend once one is chosen.
  return const NoopAnalytics();
});

/// App-wide analytics sink. Wrapped in a consent gate keyed on
/// `productAnalyticsConsent` (opt-out) — a separate flag from
/// `cloudAnalysisConsent` (audio→OpenAI), since anonymous funnel/retention
/// analytics is a different privacy question and must not be suppressed just
/// because the user declined cloud audio analysis.
final analyticsProvider = Provider<AnalyticsService>((ref) {
  final backend = ref.watch(analyticsBackendProvider);
  return ConsentGatedAnalytics(
    backend,
    () => ref.read(settingsProvider).productAnalyticsConsent,
  );
});

/// Wires the stable install token as the analytics identity, so events (and
/// especially retention) survive an iOS reinstall instead of fragmenting into a
/// fresh anonymous id. Read this once at app start (e.g. in the root widget);
/// it re-runs when the token resolves and is a no-op until consent + token are
/// available. `identify` is consent-gated by [analyticsProvider].
final analyticsIdentityProvider = Provider<void>((ref) {
  final token = ref.watch(settingsProvider.select((s) => s.appAccountToken));
  if (token.isNotEmpty) {
    ref.read(analyticsProvider).identify(token);
  }
});
