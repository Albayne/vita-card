import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/quitrr_provider.dart';
import '../widgets/level_indicator.dart';
import '../widgets/streak_calendar.dart';

class QuitrrHomeScreen extends ConsumerWidget {
  const QuitrrHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(currentStreakProvider);
    final level = ref.watch(recoveryLevelProvider);
    final logs = ref.watch(dayLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quitrr')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/quitrr/crisis'),
        backgroundColor: AppColors.danger,
        icon: const Icon(Icons.support_outlined, semanticLabel: 'Crisis support'),
        label: const Text('Crisis support'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            LevelIndicator(streak: streak, level: level),
            const SizedBox(height: 20),
            StreakCalendar(logs: logs),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Check in today',
              icon: Icons.check_circle_outline,
              onPressed: () => context.push('/quitrr/checkin'),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Peer support',
              onPressed: () => context.push('/quitrr/peer'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
