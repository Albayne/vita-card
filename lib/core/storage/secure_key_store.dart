import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../crypto/anonymous_id_generator.dart';
import '../encryption/record_encryptor.dart';

/// Wraps flutter_secure_storage for the values that must never touch Hive
/// or any network call: anonymous tokens and the local AES-256 encryption key.
class SecureKeyStore {
  SecureKeyStore._();

  static const _storage = FlutterSecureStorage();

  static const _healthWalletIdKey = 'health_wallet_id';
  static const _mentalHealthTokenKey = 'mental_health_token';
  static const _encryptionKeyKey = 'record_encryption_key';

  static Future<String> getOrCreateHealthWalletId() async {
    final existing = await _storage.read(key: _healthWalletIdKey);
    if (existing != null) return existing;
    final token = AnonymousIdGenerator.generateHealthWalletId();
    await _storage.write(key: _healthWalletIdKey, value: token);
    return token;
  }

  static Future<String> getOrCreateMentalHealthToken() async {
    final existing = await _storage.read(key: _mentalHealthTokenKey);
    if (existing != null) return existing;
    final token = AnonymousIdGenerator.generateMentalHealthToken();
    await _storage.write(key: _mentalHealthTokenKey, value: token);
    return token;
  }

  static Future<String?> readHealthWalletId() =>
      _storage.read(key: _healthWalletIdKey);

  static Future<String?> readMentalHealthToken() =>
      _storage.read(key: _mentalHealthTokenKey);

  static Future<String> getOrCreateEncryptionKey() async {
    final existing = await _storage.read(key: _encryptionKeyKey);
    if (existing != null) return existing;
    final key = RecordEncryptor.generateKey();
    await _storage.write(key: _encryptionKeyKey, value: key);
    return key;
  }

  static Future<bool> hasCompletedOnboarding() async {
    final id = await readHealthWalletId();
    return id != null;
  }

  /// Wipes all device-local identity material. Used by "clear app data".
  static Future<void> clearAll() => _storage.deleteAll();
}
