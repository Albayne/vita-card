import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;

/// AES-256-CBC encryption for health record bytes/strings.
/// The key never leaves the device — it is generated once and kept in
/// [SecureKeyStore]. This class is stateless and operates on a key/iv pair
/// supplied by the caller.
class RecordEncryptor {
  RecordEncryptor(String base64Key) : _key = enc.Key.fromBase64(base64Key);

  final enc.Key _key;

  static String generateKey() => enc.Key.fromSecureRandom(32).base64;

  String encrypt(String plainText) {
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final payload = {'iv': iv.base64, 'data': encrypted.base64};
    return base64.encode(utf8.encode(jsonEncode(payload)));
  }

  String decrypt(String cipherText) {
    final payload = jsonDecode(utf8.decode(base64.decode(cipherText))) as Map;
    final iv = enc.IV.fromBase64(payload['iv'] as String);
    final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    return encrypter.decrypt64(payload['data'] as String, iv: iv);
  }
}
