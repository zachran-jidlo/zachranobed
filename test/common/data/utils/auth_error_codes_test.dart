import 'package:flutter_test/flutter_test.dart';
import 'package:zachranobed/common/data/utils/auth_error_codes.dart';

void main() {
  group('AuthErrorCodes.isSessionRevoked', () {
    test('returns true for revoked session codes', () {
      expect(AuthErrorCodes.isSessionRevoked('user-token-expired'), isTrue);
      expect(AuthErrorCodes.isSessionRevoked('invalid-user-token'), isTrue);
      expect(AuthErrorCodes.isSessionRevoked('user-not-found'), isTrue);
      expect(AuthErrorCodes.isSessionRevoked('user-disabled'), isTrue);
    });

    test('returns false for a network failure', () {
      expect(AuthErrorCodes.isSessionRevoked('network-request-failed'), isFalse);
    });

    test('returns false for an unknown code', () {
      expect(AuthErrorCodes.isSessionRevoked('something-went-wrong'), isFalse);
      expect(AuthErrorCodes.isSessionRevoked(''), isFalse);
    });
  });
}
