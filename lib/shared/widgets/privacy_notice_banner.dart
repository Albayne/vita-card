import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Always non-dismissable. Appears on every sensitive screen so the
/// product's core promise — the patient owns the record — stays visible.
class PrivacyNoticeBanner extends StatelessWidget {
  const PrivacyNoticeBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.tealLight,
        border: Border(left: BorderSide(color: AppColors.teal, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, size: 18, color: AppColors.teal, semanticLabel: 'Privacy'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}
