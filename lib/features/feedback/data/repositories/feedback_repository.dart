import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../models/feedback_model.dart';

class FeedbackRepository {
  FeedbackRepository(this._box);

  final Box<Map> _box;

  /// Recursively cast Hive's Map<dynamic, dynamic> to Map<String, dynamic>.
  static Map<String, dynamic> deepCast(Map raw) {
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

  List<FeedbackModel> findAll() {
    return _box.values
        .map((e) => FeedbackModel.fromJson(deepCast(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  FeedbackModel? findById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return FeedbackModel.fromJson(deepCast(raw));
  }

  List<FeedbackModel> findByLessonId(String lessonId) {
    return findAll().where((f) => f.lessonId == lessonId).toList();
  }

  FeedbackModel? findLatestByLessonId(String lessonId) {
    final list = findByLessonId(lessonId);
    return list.isEmpty ? null : list.first;
  }

  List<FeedbackModel> findRecent({int limit = 10}) {
    final all = findAll();
    return all.take(limit).toList();
  }

  Future<void> save(FeedbackModel feedback) async {
    await _box.put(feedback.id, feedback.toJson());
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
