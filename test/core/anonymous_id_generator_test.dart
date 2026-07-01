import 'package:flutter_test/flutter_test.dart';
import 'package:vitacard/core/crypto/anonymous_id_generator.dart';

void main() {
  group('AnonymousIdGenerator', () {
    test('health wallet id matches ZW·XXXX·X format', () {
      final token = AnonymousIdGenerator.generateHealthWalletId();
      expect(RegExp(r'^ZW·[0-9A-Z]{4}·[0-9A-Z]$').hasMatch(token), isTrue);
    });

    test('mental health token matches MH·XXXX·X format', () {
      final token = AnonymousIdGenerator.generateMentalHealthToken();
      expect(RegExp(r'^MH·[0-9A-Z]{4}·[0-9A-Z]$').hasMatch(token), isTrue);
    });

    test('successive calls produce different tokens', () {
      final a = AnonymousIdGenerator.generateHealthWalletId();
      final b = AnonymousIdGenerator.generateHealthWalletId();
      expect(a, isNot(equals(b)));
    });
  });
}
