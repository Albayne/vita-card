import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String greetingForNow() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String formatShort(DateTime date) => DateFormat('d MMM yyyy').format(date);

  static String formatWithTime(DateTime date) =>
      DateFormat('d MMM yyyy · HH:mm').format(date);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static int daysUntilNextTest(DateTime lastTestDate, int intervalDays) {
    final nextDue = lastTestDate.add(Duration(days: intervalDays));
    return nextDue.difference(DateTime.now()).inDays.clamp(0, intervalDays);
  }
}
