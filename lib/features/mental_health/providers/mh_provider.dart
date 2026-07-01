import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/storage/secure_key_store.dart';
import '../models/counsellor_slot.dart';
import '../models/mood_log.dart';

final mhTokenProvider = FutureProvider<String?>((ref) {
  return SecureKeyStore.readMentalHealthToken();
});

final availableSlotsProvider = FutureProvider<List<CounsellorSlot>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('counsellor_slots')
      .where('available', isEqualTo: true)
      .orderBy('dateTime')
      .get();
  return snapshot.docs
      .map((doc) => CounsellorSlot.fromMap(doc.id, doc.data()))
      .toList();
});

final moodLogsProvider = Provider<List<MoodLog>>((ref) {
  final logs = HiveService.moodLogs.values.toList();
  logs.sort((a, b) => b.logDate.compareTo(a.logDate));
  return logs;
});

class MhController {
  Future<void> bookSlot(String slotId, DateTime dateTime) async {
    final token = await SecureKeyStore.readMentalHealthToken();

    // Only a slot reference and the anonymous token are ever written here —
    // never a name, phone number, or student ID.
    await FirebaseFirestore.instance.collection('counsellor_slots').doc(slotId).update({
      'available': false,
      'bookedByToken': token,
    });

    final booking = MhBooking(
      slotId: slotId,
      dateTime: dateTime,
      mhToken: token ?? '',
    );
    await HiveService.mhBookings.add(booking);

    final event = Event(
      title: 'Personal appointment',
      startDate: dateTime,
      endDate: dateTime.add(const Duration(hours: 1)),
    );
    try {
      Add2Calendar.addEvent2Cal(event);
    } catch (_) {
      // Calendar integration is a convenience; booking already succeeded.
    }
  }

  Future<void> addMoodLog(int moodScore, List<String> stressors) async {
    final log = MoodLog(
      logDate: DateTime.now(),
      moodScore: moodScore,
      stressors: stressors,
    );
    await HiveService.moodLogs.add(log);
  }
}

final mhControllerProvider = Provider<MhController>((ref) => MhController());
