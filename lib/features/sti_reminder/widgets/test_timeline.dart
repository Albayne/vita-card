import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/sti_test_log.dart';

class TestTimeline extends StatelessWidget {
  const TestTimeline({super.key, required this.logs});

  final List<StiTestLog> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'No checks logged yet',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        for (final log in logs) _TimelineEntry(log: log),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.log});

  final StiTestLog log;

  bool get _isClear => log.result == 'clear';

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppDateUtils.formatShort(log.testDate), style: AppTextStyles.headingMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final test in log.testsIncluded) _TestChip(label: test),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _isClear ? Icons.check_circle : Icons.info_outline,
                    color: _isClear ? AppColors.success : AppColors.grayMid,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isClear ? 'Clear' : 'Logged',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetails(context),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayBorder),
        ),
        child: Row(
          children: [
            Icon(
              _isClear ? Icons.check_circle : Icons.info_outline,
              color: _isClear ? AppColors.success : AppColors.grayMid,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppDateUtils.formatShort(log.testDate), style: AppTextStyles.headingSmall),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final test in log.testsIncluded) _TestChip(label: test),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestChip extends StatelessWidget {
  const _TestChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}
