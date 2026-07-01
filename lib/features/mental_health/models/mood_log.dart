import 'package:hive/hive.dart';

part 'mood_log.g.dart';

/// Strictly local. Never written to Firestore, never synced.
@HiveType(typeId: 2)
class MoodLog extends HiveObject {
  MoodLog({
    required this.logDate,
    required this.moodScore,
    required this.stressors,
  });

  @HiveField(0)
  late DateTime logDate;

  /// 1–5
  @HiveField(1)
  late int moodScore;

  @HiveField(2)
  late List<String> stressors;

  static const stressorOptions = [
    'Academic stress',
    'Loneliness',
    'Finances',
    'Relationships',
    'Sleep',
    'Anxiety',
    'Family pressure',
  ];
}
