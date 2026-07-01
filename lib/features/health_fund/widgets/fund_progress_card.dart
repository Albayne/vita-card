import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/progress_bar_card.dart';
import '../models/fund_goal.dart';

class FundProgressCard extends StatelessWidget {
  const FundProgressCard({super.key, required this.goal});

  final FundGoal goal;

  @override
  Widget build(BuildContext context) {
    final progress = goal.totalGoal == 0
        ? 0.0
        : goal.currentBalance / goal.totalGoal;

    return ProgressBarCard(
      title: 'Health fund',
      progress: progress,
      subtitle:
          '${CurrencyFormatter.format(goal.currentBalance)} saved of ${CurrencyFormatter.format(goal.totalGoal)} goal',
      color: AppColors.fundGreen,
    );
  }
}
