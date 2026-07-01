import 'package:flutter_test/flutter_test.dart';
import 'package:vitacard/features/quitrr/models/streak_record.dart';

DayLog _logFor(DateTime date, {bool stayedClean = true}) {
  return DayLog(
    date: date,
    stayedClean: stayedClean,
    triggers: const [],
    cravingIntensity: 0,
  );
}

void main() {
  group('calculateCurrentStreak', () {
    test('returns 0 for empty logs', () {
      expect(calculateCurrentStreak([]), 0);
    });

    test('counts consecutive clean days ending today', () {
      final now = DateTime.now();
      final logs = [
        _logFor(now),
        _logFor(now.subtract(const Duration(days: 1))),
        _logFor(now.subtract(const Duration(days: 2))),
      ];
      expect(calculateCurrentStreak(logs), 3);
    });

    test('stops counting at a slip day', () {
      final now = DateTime.now();
      final logs = [
        _logFor(now),
        _logFor(now.subtract(const Duration(days: 1)), stayedClean: false),
        _logFor(now.subtract(const Duration(days: 2))),
      ];
      expect(calculateCurrentStreak(logs), 1);
    });
  });

  group('getLevelForStreak', () {
    test('maps streak ranges to the correct recovery level', () {
      expect(getLevelForStreak(0), RecoveryLevel.starting);
      expect(getLevelForStreak(5), RecoveryLevel.starting);
      expect(getLevelForStreak(10), RecoveryLevel.building);
      expect(getLevelForStreak(25), RecoveryLevel.consistency);
      expect(getLevelForStreak(45), RecoveryLevel.established);
      expect(getLevelForStreak(120), RecoveryLevel.thriving);
    });
  });
}
