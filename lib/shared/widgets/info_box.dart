import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.message,
    this.color = AppColors.grayLight,
    this.icon,
  });

  final String message;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.grayDark),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(message, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
