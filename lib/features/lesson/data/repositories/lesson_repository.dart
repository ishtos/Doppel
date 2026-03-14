import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../models/lesson_model.dart';

class LessonRepository {
  LessonRepository(this._box);

  final Box<Map> _box;

  List<LessonModel> findAll() {
    return _box.values
        .map((e) => LessonModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  LessonModel? findById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return LessonModel.fromJson(Map<String, dynamic>.from(raw));
  }

  List<LessonModel> findByCategory(String category) {
    return findAll().where((l) => l.category == category).toList();
  }

  List<LessonModel> findByDifficulty(int difficulty) {
    return findAll().where((l) => l.difficulty == difficulty).toList();
  }

  List<LessonModel> search(String query) {
    final q = query.toLowerCase();
    return findAll()
        .where((l) =>
            l.title.toLowerCase().contains(q) ||
            l.transcriptText.toLowerCase().contains(q))
        .toList();
  }

  Future<void> save(LessonModel lesson) async {
    await _box.put(lesson.id, lesson.toJson());
  }

  Future<void> saveAll(List<LessonModel> lessons) async {
    final entries = {for (final l in lessons) l.id: l.toJson()};
    await _box.putAll(entries);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleBookmark(String id) async {
    final lesson = findById(id);
    if (lesson != null) {
      await save(lesson.copyWith(isBookmarked: !lesson.isBookmarked));
    }
  }
}
