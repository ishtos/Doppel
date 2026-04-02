/// Recursively cast Hive's Map<dynamic, dynamic> to Map<String, dynamic>.
// FIXED: FeedbackRepository から共通ユーティリティへ移動
Map<String, dynamic> deepCast(Map raw) {
  return raw.map((key, value) {
    if (value is Map) {
      return MapEntry(key.toString(), deepCast(value));
    } else if (value is List) {
      return MapEntry(
        key.toString(),
        value.map((e) => e is Map ? deepCast(e) : e).toList(),
      );
    }
    return MapEntry(key.toString(), value);
  });
}
