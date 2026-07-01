import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/storage/hive_service.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/info_box.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/privacy_notice_banner.dart';
import '../providers/mh_provider.dart';
import '../widgets/token_display_card.dart';

class MhHomeScreen extends ConsumerWidget {
  const MhHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(mhTokenProvider).valueOrNull;
    final bookings = HiveService.mhBookings.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mental health')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const PrivacyNoticeBanner(message: AppStrings.generalPrivacyNotice),
            const SizedBox(height: 16),
            TokenDisplayCard(token: token),
            const SizedBox(height: 16),
            if (bookings.isEmpty)
              const InfoBox(
                message: 'No appointment booked yet. Book a confidential '
                    'session whenever you are ready.',
                color: AppColors.mhBlueLight,
                icon: Icons.event_available_outlined,
              )
            else
              InfoBox(
                message: 'Your appointment: '
                    '${AppDateUtils.formatWithTime(bookings.first.dateTime)}',
                color: AppColors.mhBlueLight,
                icon: Icons.event_outlined,
              ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Book a session',
              icon: Icons.calendar_today_outlined,
              onPressed: () => context.push('/mind/book'),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Log my mood',
              onPressed: () => context.push('/mind/mood'),
            ),
          ],
        ),
      ),
    );
  }
}
