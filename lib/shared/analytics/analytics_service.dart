/// Provider-agnostic analytics seam.
///
/// Call sites depend only on this interface, so the backend (Noop today,
/// PostHog later) can be swapped in one place without touching instrumentation.
/// All product event names live in `analytics_events.dart`.
abstract class AnalyticsService {
  /// Record a product event with optional properties.
  void capture(String event, {Map<String, Object?> properties});

  /// Associate events with an (anonymous) id — the per-install token.
  void identify(String distinctId);

  /// Best-effort flush (e.g. when the app backgrounds). No-op for backends
  /// that auto-flush.
  Future<void> flush();
}

/// Discards everything. The default backend until PostHog is wired, and the
/// backend used whenever the user has not opted into cloud analysis.
class NoopAnalytics implements AnalyticsService {
  const NoopAnalytics();

  @override
  void capture(String event, {Map<String, Object?> properties = const {}}) {}

  @override
  void identify(String distinctId) {}

  @override
  Future<void> flush() async {}
}

/// Forwards to [_delegate] only while [_isEnabled] returns true, so opt-out is
/// honored centrally instead of at every call site.
class ConsentGatedAnalytics implements AnalyticsService {
  ConsentGatedAnalytics(this._delegate, this._isEnabled);

  final AnalyticsService _delegate;
  final bool Function() _isEnabled;

  @override
  void capture(String event, {Map<String, Object?> properties = const {}}) {
    if (_isEnabled()) _delegate.capture(event, properties: properties);
  }

  @override
  void identify(String distinctId) {
    if (_isEnabled()) _delegate.identify(distinctId);
  }

  @override
  Future<void> flush() => _isEnabled() ? _delegate.flush() : Future.value();
}

/// A single recorded analytics call.
class AnalyticsCall {
  const AnalyticsCall(this.event, this.properties);

  final String event;
  final Map<String, Object?> properties;
}

/// Records calls in memory. For tests and a possible in-app debug view; never
/// sends anything off-device.
class InMemoryAnalytics implements AnalyticsService {
  final List<AnalyticsCall> calls = [];
  String? distinctId;

  List<String> get events => calls.map((c) => c.event).toList();

  @override
  void capture(String event, {Map<String, Object?> properties = const {}}) {
    calls.add(AnalyticsCall(event, properties));
  }

  @override
  void identify(String distinctId) {
    this.distinctId = distinctId;
  }

  @override
  Future<void> flush() async {}
}
