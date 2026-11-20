import 'package:campus_connect/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('email accepts valid and rejects invalid values', () {
      expect(Validators.email('asha@mail.com'), isNull);
      expect(Validators.email('asha'), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('password needs at least 6 characters', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('123'), isNotNull);
    });

    test('phone needs exactly 10 digits', () {
      expect(Validators.phone('9876543210'), isNull);
      expect(Validators.phone('98765'), isNotNull);
      expect(Validators.phone('98765abcde'), isNotNull);
    });

    test('confirm password must match', () {
      expect(Validators.confirmPassword('abc123', 'abc123'), isNull);
      expect(Validators.confirmPassword('abc124', 'abc123'), isNotNull);
    });
  });
}
