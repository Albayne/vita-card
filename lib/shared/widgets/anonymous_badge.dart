import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class AnonymousBadge extends StatelessWidget {
  const AnonymousBadge({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        token,
        style: AppTextStyles.label.copyWith(color: AppColors.white),
        semanticsLabel: 'Your anonymous health wallet ID',
      ),
    );
  }
}
