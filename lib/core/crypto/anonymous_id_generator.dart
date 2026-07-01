import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// Generates the two persistent anonymous tokens VitaCard relies on:
/// a health wallet ID (ZW·XXXX·X) and a mental health token (MH·XXXX·X).
///
/// The token is derived from a random UUID, a random local seed, and the
/// current timestamp, hashed with SHA-256. None of those inputs are ever
/// stored or transmitted — only the formatted token survives generation.
class AnonymousIdGenerator {
  AnonymousIdGenerator._();

  static const _uuid = Uuid();
  static const _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static String generateHealthWalletId() => _generateToken('ZW');

  static String generateMentalHealthToken() => _generateToken('MH');

  static String _generateToken(String prefix) {
    final randomUuid = _uuid.v4();
    final localSeed = _randomSeed();
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();

    final digest = sha256.convert(utf8.encode('$randomUuid$localSeed$timestamp'));
    final hashChars = _toTokenChars(digest.bytes);

    final body = hashChars.substring(0, 4);
    final check = hashChars.substring(4, 5);

    return '$prefix·$body·$check';
  }

  static String _randomSeed() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256)).join();
  }

  static String _toTokenChars(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(_chars[byte % _chars.length]);
    }
    return buffer.toString();
  }
}
