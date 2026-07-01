import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/streak_record.dart';

class LevelIndicator extends StatelessWidget {
  const LevelIndicator({super.key, required this.streak, required this.level});

  final int streak;
  final RecoveryLevel level;

  @override
  Widget build(BuildContext context) {
    final span = level.maxDays == 999 ? 1.0 : (streak - level.minDays + 1) / (level.maxDays - level.minDays + 1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.quittrrAmberLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            streak == 1 ? '$streak day' : '$streak days',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.quittrrAmber,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 4),
          Text(level.label, style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: span.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.grayBorder,
              color: AppColors.quittrrAmber,
            ),
          ),
        ],
      ),
    );
  }
}
