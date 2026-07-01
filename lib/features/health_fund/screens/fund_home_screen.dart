import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/info_box.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../providers/fund_provider.dart';
import '../widgets/fund_health_check.dart';
import '../widgets/fund_progress_card.dart';

class FundHomeScreen extends ConsumerWidget {
  const FundHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(currentGoalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Health fund')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PrivacyNoticeBanner(message: AppStrings.fundPrivacyNotice),
            const SizedBox(height: 16),
            if (goal == null)
              const InfoBox(
                message:
                    'You have not set up a health fund yet. Calculate your '
                    'fund to see your savings goal and progress.',
                color: AppColors.fundGreenLight,
                icon: Icons.savings_outlined,
              )
            else ...[
              FundProgressCard(goal: goal),
              const SizedBox(height: 16),
              FundHealthCheck(goal: goal),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Calculate my fund',
              icon: Icons.calculate_outlined,
              onPressed: () => context.push('/fund/calculator'),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Manage wallets',
              onPressed: () => context.push('/fund/wallets'),
            ),
          ],
        ),
      ),
    );
  }
}
