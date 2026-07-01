import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TestCountdownCard extends StatelessWidget {
  const TestCountdownCard({super.key, required this.daysUntilDue});

  final int? daysUntilDue;

  @override
  Widget build(BuildContext context) {
    final days = daysUntilDue;

    if (days == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.grayLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Log your first check to start tracking',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    final overdue = days <= 0;
    final Color color;
    if (overdue) {
      color = AppColors.danger;
    } else if (days < 7) {
      color = AppColors.danger;
    } else if (days <= 14) {
      color = AppColors.warning;
    } else {
      color = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            overdue ? 'Overdue' : '$days',
            style: AppTextStyles.headingLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: overdue ? 28 : 40,
            ),
          ),
          if (!overdue)
            Text(
              days == 1 ? 'day until next check' : 'days until next check',
              style: AppTextStyles.body,
            ),
        ],
      ),
    );
  }
}
