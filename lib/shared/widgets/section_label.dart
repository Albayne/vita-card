import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text.toUpperCase(), style: AppTextStyles.label),
    );
  }
}
