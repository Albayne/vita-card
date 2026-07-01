import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../providers/mh_provider.dart';
import '../widgets/slot_card.dart';

class MhBookScreen extends ConsumerWidget {
  const MhBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(availableSlotsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book a session')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PrivacyNoticeBanner(message: AppStrings.generalPrivacyNotice),
            const SizedBox(height: 16),
            slotsAsync.when(
              data: (slots) {
                if (slots.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No slots available right now. Please check back soon.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final slot in slots)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SlotCard(
                          slot: slot,
                          onTap: () => context.push('/mind/confirm', extra: slot),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Could not load slots. Check your connection and try again.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
