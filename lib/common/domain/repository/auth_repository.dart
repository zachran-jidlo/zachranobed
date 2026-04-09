/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Signs in with [email] and [password]. Returns `true` on success, `false` on invalid credentials.
  Future<bool> signIn(String email, String password);

  /// Signs out the current user identified by [entityId].
  Future<void> signOut(String? entityId);

  /// Re-authenticates the current user with their [password].
  Future<void> reauthenticateUser(String password);

  /// Changes the current user's password to [password].
  Future<void> changePassword(String password);

  /// Sends a password reset email to [email].
  Future<void> resetPassword(String email);
}
