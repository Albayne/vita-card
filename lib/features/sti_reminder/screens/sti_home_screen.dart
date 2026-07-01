import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/storage/secure_key_store.dart';
import '../../../shared/widgets/anonymous_badge.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../../../shared/widgets/section_label.dart';
import '../providers/sti_provider.dart';
import '../widgets/test_countdown_card.dart';
import '../widgets/test_timeline.dart';

class StiHomeScreen extends ConsumerWidget {
  const StiHomeScreen({super.key});

  void _copyToken(BuildContext context, String token) {
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $token')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysUntilDue = ref.watch(nextTestDueProvider);
    final logs = ref.watch(logsProvider);
    final walletId = ref.watch(_walletIdProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Health checks')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PrivacyNoticeBanner(message: AppStrings.generalPrivacyNotice),
            const SizedBox(height: 16),
            TestCountdownCard(daysUntilDue: daysUntilDue),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your clinic token', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 4),
                    const Text('Show this to your clinic. No name needed.', style: AppTextStyles.caption),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: walletId == null ? null : () => _copyToken(context, walletId),
                      child: Center(child: AnonymousBadge(token: walletId ?? '···')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Log a check',
              icon: Icons.add_circle_outline,
              onPressed: () => context.push('/sti/log'),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'View reminders',
              onPressed: () => context.push('/sti/reminders'),
            ),
            const SizedBox(height: 24),
            const SectionLabel(text: 'History'),
            TestTimeline(logs: logs),
          ],
        ),
      ),
    );
  }
}

final _walletIdProvider = FutureProvider<String?>((ref) {
  return SecureKeyStore.readHealthWalletId();
});
