import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../features/feedback/data/models/feedback_model.dart';
import '../../features/lesson/data/models/lesson_model.dart';
import '../../features/progress/data/models/user_progress_model.dart';

class DbService {
  static const _lessonsBox = 'lessons';
  static const _feedbacksBox = 'feedbacks';
  static const _progressBox = 'progress';

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(_LessonModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(_FeedbackModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(_ProblemWordAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(_UserProgressModelAdapter());
    }

    // Open boxes
    await Hive.openBox<Map>(_lessonsBox);
    await Hive.openBox<Map>(_feedbacksBox);
    await Hive.openBox<Map>(_progressBox);
  }

  static Box<Map> get lessonsBox => Hive.box<Map>(_lessonsBox);
  static Box<Map> get feedbacksBox => Hive.box<Map>(_feedbacksBox);
  static Box<Map> get progressBox => Hive.box<Map>(_progressBox);
}

// Manual Hive adapters for freezed models (stored as JSON maps)

class _LessonModelAdapter extends TypeAdapter<LessonModel> {
  @override
  final int typeId = 0;

  @override
  LessonModel read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return LessonModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, LessonModel obj) {
    writer.writeMap(obj.toJson());
  }
}

class _FeedbackModelAdapter extends TypeAdapter<FeedbackModel> {
  @override
  final int typeId = 1;

  @override
  FeedbackModel read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return FeedbackModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, FeedbackModel obj) {
    writer.writeMap(obj.toJson());
  }
}

class _ProblemWordAdapter extends TypeAdapter<ProblemWord> {
  @override
  final int typeId = 2;

  @override
  ProblemWord read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return ProblemWord.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, ProblemWord obj) {
    writer.writeMap(obj.toJson());
  }
}

class _UserProgressModelAdapter extends TypeAdapter<UserProgressModel> {
  @override
  final int typeId = 3;

  @override
  UserProgressModel read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return UserProgressModel.fromJson(map);
  }

  @override
  void write(BinaryWriter writer, UserProgressModel obj) {
    writer.writeMap(obj.toJson());
  }
}
