import 'package:hive/hive.dart';

part 'health_record.g.dart';

/// Phase 2 placeholder. Will hold patient-owned clinical records, encrypted
/// at rest, never synced without explicit per-record consent.
@HiveType(typeId: 7)
class HealthRecord extends HiveObject {
  HealthRecord({
    required this.recordDate,
    required this.category,
    required this.encryptedSummary,
    required this.anonymousId,
  });

  @HiveField(0)
  late DateTime recordDate;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late String encryptedSummary;

  @HiveField(3)
  late String anonymousId;
}
