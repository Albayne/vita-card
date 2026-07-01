import 'package:flutter_test/flutter_test.dart';
import 'package:vitacard/core/encryption/record_encryptor.dart';

void main() {
  group('RecordEncryptor', () {
    test('encrypts and decrypts round-trip correctly', () {
      final key = RecordEncryptor.generateKey();
      final encryptor = RecordEncryptor(key);

      const plainText = 'ZW·9F2A·C — clear result logged';
      final cipherText = encryptor.encrypt(plainText);

      expect(cipherText, isNot(equals(plainText)));
      expect(encryptor.decrypt(cipherText), equals(plainText));
    });

    test('different keys cannot decrypt each other\'s output', () {
      final encryptorA = RecordEncryptor(RecordEncryptor.generateKey());
      final encryptorB = RecordEncryptor(RecordEncryptor.generateKey());

      final cipherText = encryptorA.encrypt('sensitive data');

      expect(() => encryptorB.decrypt(cipherText), throwsA(anything));
    });

    test('encrypting the same plaintext twice yields different ciphertext', () {
      final encryptor = RecordEncryptor(RecordEncryptor.generateKey());
      final first = encryptor.encrypt('repeat me');
      final second = encryptor.encrypt('repeat me');
      expect(first, isNot(equals(second)));
    });
  });
}
