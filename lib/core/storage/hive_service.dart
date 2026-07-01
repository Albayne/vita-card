import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/sti_reminder/models/sti_test_log.dart';
import '../../features/mental_health/models/mood_log.dart';
import '../../features/mental_health/models/counsellor_slot.dart';
import '../../features/quitrr/models/streak_record.dart';
import '../../features/health_fund/models/fund_goal.dart';
import '../../features/health_fund/models/wallet_config.dart';
import '../../features/health_wallet/models/health_record.dart';
import 'secure_key_store.dart';

/// Initialises Hive and opens every box used by VitaCard. Boxes holding
/// health data are opened with an AES-256 key from [SecureKeyStore] that is
/// generated on-device and never transmitted.
class HiveService {
  HiveService._();

  static const stiLogsBox = 'sti_logs';
  static const moodLogsBox = 'mood_logs';
  static const mhBookingsBox = 'mh_bookings';
  static const dayLogsBox = 'quitrr_day_logs';
  static const fundGoalBox = 'fund_goal';
  static const walletConfigBox = 'wallet_config';
  static const healthRecordsBox = 'health_records';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(StiTestLogAdapter());
    Hive.registerAdapter(MoodLogAdapter());
    Hive.registerAdapter(MhBookingAdapter());
    Hive.registerAdapter(DayLogAdapter());
    Hive.registerAdapter(FundGoalAdapter());
    Hive.registerAdapter(WalletConfigAdapter());
    Hive.registerAdapter(HealthRecordAdapter());

    final keyBytes = await _encryptionCipherKey();

    await Hive.openBox<StiTestLog>(stiLogsBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<MoodLog>(moodLogsBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<MhBooking>(mhBookingsBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<DayLog>(dayLogsBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<FundGoal>(fundGoalBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<WalletConfig>(walletConfigBox, encryptionCipher: HiveAesCipher(keyBytes));
    await Hive.openBox<HealthRecord>(healthRecordsBox, encryptionCipher: HiveAesCipher(keyBytes));
  }

  static Future<List<int>> _encryptionCipherKey() async {
    final base64Key = await SecureKeyStore.getOrCreateEncryptionKey();
    // RecordEncryptor.generateKey() produces a 32-byte AES key encoded as
    // base64; decode it directly so HiveAesCipher gets the full key entropy.
    return base64Decode(base64Key);
  }

  static Box<StiTestLog> get stiLogs => Hive.box<StiTestLog>(stiLogsBox);
  static Box<MoodLog> get moodLogs => Hive.box<MoodLog>(moodLogsBox);
  static Box<MhBooking> get mhBookings => Hive.box<MhBooking>(mhBookingsBox);
  static Box<DayLog> get dayLogs => Hive.box<DayLog>(dayLogsBox);
  static Box<FundGoal> get fundGoal => Hive.box<FundGoal>(fundGoalBox);
  static Box<WalletConfig> get walletConfig => Hive.box<WalletConfig>(walletConfigBox);
  static Box<HealthRecord> get healthRecords => Hive.box<HealthRecord>(healthRecordsBox);

  static Future<void> clearAll() async {
    await stiLogs.clear();
    await moodLogs.clear();
    await mhBookings.clear();
    await dayLogs.clear();
    await fundGoal.clear();
    await walletConfig.clear();
    await healthRecords.clear();
  }
}
