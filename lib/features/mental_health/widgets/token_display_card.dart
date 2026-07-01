import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TokenDisplayCard extends StatelessWidget {
  const TokenDisplayCard({super.key, required this.token});

  final String? token;

  void _copy(BuildContext context) {
    if (token == null) return;
    Clipboard.setData(ClipboardData(text: token!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your mental health token', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: token == null ? null : () => _copy(context),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.mhBlueLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.mhBlue, width: 1),
                ),
                child: Center(
                  child: Text(
                    token ?? 'Generating…',
                    style: const TextStyle(
                      color: AppColors.mhBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This is how the counsellor's office identifies you. No name needed.",
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
