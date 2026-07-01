import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notifications/notification_service.dart';

/// Wraps Firebase Auth phone verification with an anonymous fallback.
///
/// The phone number itself never leaves Firebase Auth's own backend — it is
/// passed straight to [verifyPhoneNumber] and is never written to Firestore
/// or Hive. The only thing persisted server-side is the FCM device token,
/// keyed by the Auth UID (a random, non-personal identifier), so the device
/// can receive push notifications.
class AuthService {
  AuthService._();

  static final _auth = FirebaseAuth.instance;

  static String? get currentUid => _auth.currentUser?.uid;

  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onError,
    required Future<void> Function() onAutoVerified,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        await onAutoVerified();
      },
      verificationFailed: (e) {
        onError(e.message ?? 'Could not verify this number.');
      },
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  static Future<bool> confirmCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  static Future<void> signInAnonymously() async {
    if (_auth.currentUser != null) return;
    await _auth.signInAnonymously();
  }

  /// Registers this device's FCM token under the Auth UID so server-pushed
  /// reminders can reach it. No personal data is written — see class doc.
  static Future<void> registerFcmToken() async {
    final uid = currentUid;
    final token = await NotificationService.getFcmToken();
    if (uid == null || token == null) return;
    await FirebaseFirestore.instance.collection('device_tokens').doc(uid).set({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
