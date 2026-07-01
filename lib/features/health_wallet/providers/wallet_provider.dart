import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../models/health_record.dart';

final healthRecordsProvider = Provider<List<HealthRecord>>((ref) {
  return HiveService.healthRecords.values.toList()
    ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
});
