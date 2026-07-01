import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../models/fund_goal.dart';

class FundHealthCheck extends StatelessWidget {
  const FundHealthCheck({super.key, required this.goal});

  final FundGoal goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fund health check', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            _row('GP visit', goal.gpVisitCoverage),
            _row('Pharmacy', goal.pharmacyCoverage),
            _row('Emergency buffer', goal.emergencyBuffer),
            _row('Hospital stay', goal.totalGoal),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double cost) {
    final status = getCoverageStatus(goal.currentBalance, cost);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.body),
          ),
          Text(CurrencyFormatter.format(cost), style: AppTextStyles.caption),
          const SizedBox(width: 8),
          _StatusChip(status: status),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final CoverageStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (status) {
      CoverageStatus.covered => (AppColors.success, Icons.check_circle, 'Covered'),
      CoverageStatus.partial => (AppColors.warning, Icons.adjust, 'Partial'),
      CoverageStatus.notCovered => (AppColors.danger, Icons.cancel, 'Not covered'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
