import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/storage/secure_key_store.dart';
import '../../../shared/utils/date_utils.dart';
import '../models/sti_test_log.dart';

const stiReminderNotificationId = 9001;
const stiDefaultIntervalDays = 90;

final _stiRefreshProvider = StateProvider<int>((ref) => 0);

final logsProvider = Provider<List<StiTestLog>>((ref) {
  ref.watch(_stiRefreshProvider);
  final logs = HiveService.stiLogs.values.toList();
  final sorted = [...logs]..sort((a, b) => b.testDate.compareTo(a.testDate));
  return sorted;
});

final nextTestDueProvider = Provider<int?>((ref) {
  final logs = ref.watch(logsProvider);
  if (logs.isEmpty) return null;
  return AppDateUtils.daysUntilNextTest(logs.first.testDate, stiDefaultIntervalDays);
});

class StiController extends StateNotifier<int> {
  StiController(this._ref) : super(0);

  final Ref _ref;

  Future<void> addLog({
    required List<String> testsIncluded,
    required String result,
  }) async {
    final anonymousId = await SecureKeyStore.readHealthWalletId() ?? '';
    final log = StiTestLog(
      testDate: DateTime.now(),
      testsIncluded: testsIncluded,
      result: result,
      anonymousId: anonymousId,
    );
    await HiveService.stiLogs.add(log);
    _ref.read(_stiRefreshProvider.notifier).state++;
    await refreshReminder(intervalDays: stiDefaultIntervalDays);
  }

  Future<void> refreshReminder({required int intervalDays}) async {
    final box = HiveService.stiLogs;
    await NotificationService.cancel(stiReminderNotificationId);
    if (box.isEmpty) return;
    final last = box.values.toList()
      ..sort((a, b) => b.testDate.compareTo(a.testDate));
    final nextDue = last.first.testDate.add(Duration(days: intervalDays));
    await NotificationService.scheduleAt(
      id: stiReminderNotificationId,
      title: AppStrings.stiReminderTitle,
      body: AppStrings.stiReminderBody,
      scheduledDate: nextDue,
    );
  }

  Future<void> cancelReminder() => NotificationService.cancel(stiReminderNotificationId);
}

final stiControllerProvider = StateNotifierProvider<StiController, int>(
  (ref) => StiController(ref),
);
