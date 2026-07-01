import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/counsellor_slot.dart';
import '../providers/mh_provider.dart';
import '../widgets/token_display_card.dart';

class MhConfirmScreen extends ConsumerStatefulWidget {
  const MhConfirmScreen({super.key, this.slot});

  final CounsellorSlot? slot;

  @override
  ConsumerState<MhConfirmScreen> createState() => _MhConfirmScreenState();
}

class _MhConfirmScreenState extends ConsumerState<MhConfirmScreen> {
  bool _booking = false;
  bool _confirmed = false;

  Future<void> _confirm() async {
    final slot = widget.slot;
    if (slot == null) return;
    setState(() => _booking = true);
    await ref.read(mhControllerProvider).bookSlot(slot.id, slot.dateTime);
    if (!mounted) return;
    setState(() {
      _booking = false;
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(mhTokenProvider).valueOrNull;
    final slot = widget.slot;

    if (slot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirm booking')),
        body: const Center(child: Text('No slot selected.')),
      );
    }

    if (_confirmed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirm booking')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 56),
              const SizedBox(height: 16),
              const Text('You are booked', style: AppTextStyles.headingLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                AppDateUtils.formatWithTime(slot.dateTime),
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Done', onPressed: () => context.go('/mind')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm booking')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('You are booking', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Text(AppDateUtils.formatWithTime(slot.dateTime), style: AppTextStyles.headingMedium),
            Text(
              '${slot.durationMinutes} min · ${slot.format == 'online' ? 'Online' : 'In person'} · ${slot.location}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),
            TokenDisplayCard(token: token),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Confirm booking',
              onPressed: _booking ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
