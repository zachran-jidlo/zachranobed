/// Firebase Auth error codes.
class AuthErrorCodes {
  const AuthErrorCodes._();

  /// Codes meaning the credential is gone from the server for good.
  static const _sessionRevokedCodes = {
    'user-token-expired',
    'invalid-user-token',
    'user-not-found',
    'user-disabled',
  };

  /// Whether [code] means the session was revoked. Network and unknown
  /// failures are not revocations and return `false`.
  static bool isSessionRevoked(String code) => _sessionRevokedCodes.contains(code);
}
