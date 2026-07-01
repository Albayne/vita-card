import 'package:hive/hive.dart';

part 'counsellor_slot.g.dart';

/// Mirrors /counsellor_slots/{slotId} in Firestore.
/// No student name, phone number, or student ID is ever present here.
class CounsellorSlot {
  CounsellorSlot({
    required this.id,
    required this.dateTime,
    required this.durationMinutes,
    required this.format,
    required this.location,
    required this.available,
    this.bookedByToken,
  });

  final String id;
  final DateTime dateTime;
  final int durationMinutes;
  final String format; // 'in_person' | 'online'
  final String location;
  final bool available;
  final String? bookedByToken; // MH·XXXX·X

  factory CounsellorSlot.fromMap(String id, Map<String, dynamic> map) {
    return CounsellorSlot(
      id: id,
      dateTime: (map['dateTime'] as dynamic).toDate() as DateTime,
      durationMinutes: map['durationMinutes'] as int,
      format: map['format'] as String,
      location: map['location'] as String,
      available: map['available'] as bool,
      bookedByToken: map['bookedByToken'] as String?,
    );
  }
}

/// Local record of a booking, keyed by the device's own MH token.
@HiveType(typeId: 6)
class MhBooking extends HiveObject {
  MhBooking({
    required this.slotId,
    required this.dateTime,
    required this.mhToken,
  });

  @HiveField(0)
  late String slotId;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late String mhToken;
}
