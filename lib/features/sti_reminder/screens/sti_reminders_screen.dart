import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../shared/widgets/ghost_button.dart';
import '../../../shared/widgets/info_box.dart';
import '../providers/sti_provider.dart';

const _intervalPrefKey = 'sti_reminder_interval_days';
const _enabledPrefKey = 'sti_reminder_enabled';

class StiRemindersScreen extends ConsumerStatefulWidget {
  const StiRemindersScreen({super.key});

  @override
  ConsumerState<StiRemindersScreen> createState() => _StiRemindersScreenState();
}

class _StiRemindersScreenState extends ConsumerState<StiRemindersScreen> {
  int _intervalDays = stiDefaultIntervalDays;
  bool _enabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _intervalDays = prefs.getInt(_intervalPrefKey) ?? stiDefaultIntervalDays;
      _enabled = prefs.getBool(_enabledPrefKey) ?? true;
      _loaded = true;
    });
  }

  Future<void> _setInterval(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_intervalPrefKey, days);
    setState(() => _intervalDays = days);
    if (_enabled) {
      await ref.read(stiControllerProvider.notifier).refreshReminder(intervalDays: days);
    }
  }

  Future<void> _setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledPrefKey, enabled);
    setState(() => _enabled = enabled);
    if (enabled) {
      await ref.read(stiControllerProvider.notifier).refreshReminder(intervalDays: _intervalDays);
    } else {
      await ref.read(stiControllerProvider.notifier).cancelReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Reminders on', style: AppTextStyles.headingSmall),
              subtitle: const Text('Get a notification when your next check is due', style: AppTextStyles.caption),
              value: _enabled,
              onChanged: _setEnabled,
            ),
            const SizedBox(height: 12),
            const Text('Check interval', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final days in [30, 60, 90, 180])
                  ChoiceChip(
                    label: Text(_intervalLabel(days)),
                    selected: _intervalDays == days,
                    onSelected: (_) => _setInterval(days),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const InfoBox(
              message: 'Notifications never name a test or condition — only '
                  '"Health check reminder."',
              icon: Icons.notifications_off_outlined,
            ),
            const SizedBox(height: 16),
            GhostButton(
              label: 'Send a test notification',
              onPressed: () => NotificationService.showNow(
                id: 9999,
                title: AppStrings.stiReminderTitle,
                body: AppStrings.stiReminderBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _intervalLabel(int days) {
    switch (days) {
      case 30:
        return 'Monthly';
      case 60:
        return 'Every 2 months';
      case 90:
        return 'Every 3 months';
      case 180:
        return 'Every 6 months';
      default:
        return '$days days';
    }
  }
}
