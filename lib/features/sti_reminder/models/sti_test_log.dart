import 'package:hive/hive.dart';

part 'sti_test_log.g.dart';

@HiveType(typeId: 1)
class StiTestLog extends HiveObject {
  StiTestLog({
    required this.testDate,
    required this.testsIncluded,
    required this.result,
    required this.anonymousId,
  });

  @HiveField(0)
  late DateTime testDate;

  @HiveField(1)
  late List<String> testsIncluded;

  /// 'clear' or 'positive'
  @HiveField(2)
  late String result;

  /// ZW·XXXX·X — local reference only, never transmitted.
  @HiveField(3)
  late String anonymousId;
}
