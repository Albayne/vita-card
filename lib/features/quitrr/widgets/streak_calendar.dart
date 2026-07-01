import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/streak_record.dart';

class StreakCalendar extends StatelessWidget {
  const StreakCalendar({super.key, required this.logs, this.daysToShow = 30});

  final List<DayLog> logs;
  final int daysToShow;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final logsByDay = <DateTime, DayLog>{};
    for (final log in logs) {
      final key = DateTime(log.date.year, log.date.month, log.date.day);
      logsByDay[key] = log;
    }

    final days = List.generate(daysToShow, (i) {
      final date = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: daysToShow - 1 - i));
      return logsByDay[date];
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last $daysToShow days', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((log) => _DayDot(log: log)).toList(),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            _Legend(color: AppColors.success, label: 'Clean'),
            SizedBox(width: 16),
            _Legend(color: AppColors.quittrrAmber, label: 'Logged'),
            SizedBox(width: 16),
            _Legend(color: AppColors.grayBorder, label: 'No entry'),
          ],
        ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.log});

  final DayLog? log;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (log == null) {
      color = AppColors.grayBorder;
    } else if (log!.stayedClean) {
      color = AppColors.success;
    } else {
      color = AppColors.quittrrAmber;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
