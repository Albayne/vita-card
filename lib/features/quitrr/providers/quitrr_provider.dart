import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../models/peer_post.dart';
import '../models/streak_record.dart';

final dayLogsProvider = Provider<List<DayLog>>((ref) {
  final logs = HiveService.dayLogs.values.toList();
  logs.sort((a, b) => b.date.compareTo(a.date));
  return logs;
});

final currentStreakProvider = Provider<int>((ref) {
  final logs = ref.watch(dayLogsProvider);
  return calculateCurrentStreak(logs);
});

final recoveryLevelProvider = Provider<RecoveryLevel>((ref) {
  final streak = ref.watch(currentStreakProvider);
  return getLevelForStreak(streak);
});

const _blockedTerms = [
  'fuck',
  'shit',
  'bitch',
  'asshole',
  'cunt',
  'nigger',
  'nigga',
  'faggot',
  'whore',
  'slut',
  'retard',
  'kaffir',
  'bastard',
  'dick',
  'pussy',
];

bool containsBlockedLanguage(String text) {
  final lower = text.toLowerCase();
  return _blockedTerms.any((term) => lower.contains(term));
}

String _generateAnonymousCode() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const digits = '0123456789';
  final random = Random.secure();
  final letter = letters[random.nextInt(letters.length)];
  final digit = digits[random.nextInt(digits.length)];
  return '$letter$digit';
}

class QuitrrController {
  QuitrrController(this.ref);

  final Ref ref;

  Future<void> logCheckIn({
    required bool stayedClean,
    List<String> triggers = const [],
    required int cravingIntensity,
  }) async {
    final log = DayLog(
      date: DateTime.now(),
      stayedClean: stayedClean,
      triggers: stayedClean ? const [] : triggers,
      cravingIntensity: cravingIntensity,
    );
    await HiveService.dayLogs.add(log);
    ref.invalidate(dayLogsProvider);
  }

  Future<bool> submitPost(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return false;
    if (containsBlockedLanguage(trimmed)) return false;

    final post = PeerPost(
      id: '',
      anonymousCode: _generateAnonymousCode(),
      content: trimmed,
      createdAt: DateTime.now(),
      reported: false,
    );

    await FirebaseFirestore.instance.collection('peer_posts').add(post.toMap());
    return true;
  }

  Future<void> reportPost(String postId) async {
    await FirebaseFirestore.instance
        .collection('peer_posts')
        .doc(postId)
        .update({'reported': true});
  }
}

final quitrrControllerProvider = Provider<QuitrrController>((ref) {
  return QuitrrController(ref);
});

final postsProvider = StreamProvider<List<PeerPost>>((ref) {
  return FirebaseFirestore.instance
      .collection('peer_posts')
      .where('reported', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PeerPost.fromMap(doc.id, doc.data())).toList());
});
