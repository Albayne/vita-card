import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/storage/secure_key_store.dart';
import '../../../shared/utils/date_utils.dart';
import '../../quitrr/models/streak_record.dart';

class ReminderItem {
  const ReminderItem({
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.route,
  });

  final String title;
  final String subtitle;
  final DateTime dueDate;
  final String route;
}

final healthWalletIdProvider = FutureProvider<String?>((ref) {
  return SecureKeyStore.readHealthWalletId();
});

final fundStatusProvider = Provider<String>((ref) {
  final box = HiveService.fundGoal;
  if (box.isEmpty) return 'Set up your fund';
  final goal = box.getAt(0)!;
  final pct = goal.totalGoal == 0 ? 0 : (goal.currentBalance / goal.totalGoal * 100).round();
  return 'ZWG ${goal.currentBalance.toStringAsFixed(0)} · $pct% of goal';
});

final stiStatusProvider = Provider<String>((ref) {
  final box = HiveService.stiLogs;
  if (box.isEmpty) return 'No checks logged yet';
  final last = box.values.last;
  final days = AppDateUtils.daysUntilNextTest(last.testDate, 90);
  return days <= 0 ? 'Check overdue' : 'Next check in $days days';
});

final quitrrStatusProvider = Provider<String>((ref) {
  final logs = HiveService.dayLogs.values.toList();
  final streak = calculateCurrentStreak(logs);
  final level = getLevelForStreak(streak);
  return '$streak day streak · ${level.label}';
});

final mhStatusProvider = Provider<String>((ref) {
  final box = HiveService.mhBookings;
  if (box.isEmpty) return 'No appointment booked';
  final next = box.values.first;
  return 'Appointment ${AppDateUtils.formatShort(next.dateTime)}';
});

final remindersFeedProvider = Provider<List<ReminderItem>>((ref) {
  final items = <ReminderItem>[];

  final stiBox = HiveService.stiLogs;
  if (stiBox.isNotEmpty) {
    final last = stiBox.values.last;
    final due = last.testDate.add(const Duration(days: 90));
    items.add(ReminderItem(
      title: 'Health check reminder',
      subtitle: 'Tap to log when done',
      dueDate: due,
      route: '/sti',
    ));
  }

  final fundBox = HiveService.fundGoal;
  if (fundBox.isNotEmpty) {
    items.add(ReminderItem(
      title: 'Time to top up',
      subtitle: 'Keep your health fund on track',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      route: '/fund',
    ));
  }

  final mhBox = HiveService.mhBookings;
  if (mhBox.isNotEmpty) {
    final next = mhBox.values.first;
    items.add(ReminderItem(
      title: 'Personal appointment reminder',
      subtitle: AppDateUtils.formatWithTime(next.dateTime),
      dueDate: next.dateTime,
      route: '/mind',
    ));
  }

  items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return items;
});
