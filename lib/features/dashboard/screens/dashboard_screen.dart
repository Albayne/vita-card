import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/widgets/anonymous_badge.dart';
import '../../../shared/widgets/section_label.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/feature_card.dart';
import '../widgets/reminders_feed.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthWalletId = ref.watch(healthWalletIdProvider).valueOrNull ?? '···';
    final fundStatus = ref.watch(fundStatusProvider);
    final stiStatus = ref.watch(stiStatusProvider);
    final mhStatus = ref.watch(mhStatusProvider);
    final quitrrStatus = ref.watch(quitrrStatusProvider);
    final reminders = ref.watch(remindersFeedProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppDateUtils.greetingForNow(), style: AppTextStyles.headingLarge),
                AnonymousBadge(token: healthWalletId),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                FeatureCard(
                  icon: Icons.savings_outlined,
                  title: 'Health Fund',
                  statusText: fundStatus,
                  accentColor: AppColors.fundGreen,
                  onTap: () => context.go('/fund'),
                ),
                FeatureCard(
                  icon: Icons.shield_outlined,
                  title: 'STI / HIV',
                  statusText: stiStatus,
                  accentColor: AppColors.stiRed,
                  onTap: () => context.go('/sti'),
                ),
                FeatureCard(
                  icon: Icons.self_improvement_outlined,
                  title: 'Mental Health',
                  statusText: mhStatus,
                  accentColor: AppColors.mhBlue,
                  onTap: () => context.go('/mind'),
                ),
                FeatureCard(
                  icon: Icons.timeline_outlined,
                  title: 'Quitrr',
                  statusText: quitrrStatus,
                  accentColor: AppColors.quittrrAmber,
                  onTap: () => context.go('/quitrr'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionLabel(text: 'Reminders'),
            RemindersFeed(items: reminders),
          ],
        ),
      ),
    );
  }
}
