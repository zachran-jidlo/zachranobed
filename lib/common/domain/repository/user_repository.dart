import 'package:zachranobed/common/domain/model/user_data.dart';

/// Repository to manage user authentication and data operations.
abstract class UserRepository {
  /// Signs in with [email] and [password]. Returns `true` on success.
  Future<bool> signIn(String email, String password);

  /// Signs out the current user with the given [entityId].
  Future<void> signOut(String? entityId);

  /// Re-authenticates the current user with [password].
  Future<void> reauthenticateUser(String password);

  /// Updates the current user's password to [password].
  Future<void> changePassword(String password);

  /// Sends a password reset email to [email].
  Future<void> resetPassword(String email);

  /// Gets the current user's data.
  ///
  /// Returns a [Future] that completes with [UserData] for the authenticated user or null if the user is not
  /// authenticated or data cannot be retrieved.
  Future<UserData?> getUserData();

  /// Stream that emits when user data changes (e.g., after login or logout).
  Stream<UserData?> observeUserData();

  /// Notifies listeners that user data has changed.
  ///
  /// Call this after successful login to trigger observers like [AppRoot]
  /// to perform post-login checks.
  void notifyUserDataChanged(UserData? userData);

  /// Checks if the onboarding for UI changes should be shown for the given entity.
  ///
  /// Returns `true` if the flag is set to `true`, otherwise returns `false`
  /// (including when the flag is `null` or missing).
  Future<bool> shouldShowOnboardingForUiChanges(String entityId);

  /// Removes the onboarding for UI changes flag from the entity document.
  Future<void> removeOnboardingForUiChangesFlag(String entityId);

  /// Updates device info (app version, build number, platform) for the given entity.
  Future<void> updateDeviceInfo({
    required String entityId,
    required String deviceId,
    required String appVersion,
    required String buildNumber,
    required String platform,
  });
}
