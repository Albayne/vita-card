import 'package:hive/hive.dart';

part 'streak_record.g.dart';

/// Purely behavioural data. No substance named, no identity attached.
@HiveType(typeId: 3)
class DayLog extends HiveObject {
  DayLog({
    required this.date,
    required this.stayedClean,
    required this.triggers,
    required this.cravingIntensity,
  });

  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late bool stayedClean;

  /// Only populated on slip days.
  @HiveField(2)
  late List<String> triggers;

  /// 0–10
  @HiveField(3)
  late int cravingIntensity;
}

enum RecoveryLevel {
  starting(1, 7, 'Starting fresh'),
  building(8, 20, 'Building momentum'),
  consistency(21, 29, 'Finding consistency'),
  established(30, 89, 'Established pattern'),
  thriving(90, 999, 'Thriving');

  const RecoveryLevel(this.minDays, this.maxDays, this.label);
  final int minDays;
  final int maxDays;
  final String label;
}

RecoveryLevel getLevelForStreak(int streak) {
  if (streak <= 0) return RecoveryLevel.starting;
  return RecoveryLevel.values.firstWhere(
    (l) => streak >= l.minDays && streak <= l.maxDays,
    orElse: () => RecoveryLevel.thriving,
  );
}

int calculateCurrentStreak(List<DayLog> logs) {
  if (logs.isEmpty) return 0;
  final sorted = [...logs]..sort((a, b) => b.date.compareTo(a.date));
  int streak = 0;
  DateTime expected = DateTime.now();
  for (final log in sorted) {
    if (_isSameDay(log.date, expected) && log.stayedClean) {
      streak++;
      expected = expected.subtract(const Duration(days: 1));
    } else if (_isSameDay(log.date, expected) && !log.stayedClean) {
      break;
    }
  }
  return streak;
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
