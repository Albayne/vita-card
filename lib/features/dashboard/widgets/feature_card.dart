import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

enum UrgencyLevel { none, low, medium, high }

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.statusText,
    required this.accentColor,
    required this.onTap,
    this.urgencyLevel = UrgencyLevel.none,
  });

  final IconData icon;
  final String title;
  final String statusText;
  final Color accentColor;
  final VoidCallback onTap;
  final UrgencyLevel urgencyLevel;

  Color get _borderColor {
    switch (urgencyLevel) {
      case UrgencyLevel.high:
        return AppColors.danger;
      case UrgencyLevel.medium:
        return AppColors.warning;
      case UrgencyLevel.low:
        return AppColors.grayBorder;
      case UrgencyLevel.none:
        return AppColors.grayBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _borderColor,
            width: urgencyLevel == UrgencyLevel.none ? 0.5 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 26, semanticLabel: title),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.headingSmall),
            const SizedBox(height: 4),
            Text(statusText, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
