import 'dart:async';

import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/data/service/entity_service.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Implementation of the [UserRepository] via Firebase services.
class FirebaseUserRepository implements UserRepository {
  final AuthService _authService;
  final EntityService _entityService;
  final _userDataController = StreamController<UserData?>.broadcast();

  /// Creates a new instance of [FirebaseUserRepository].
  ///
  /// Subscribes to Firebase Auth state changes so that any session termination
  /// (explicit sign-out, token revocation, account disabled, etc.) is
  /// automatically propagated through [observeUserData].
  FirebaseUserRepository(this._authService, this._entityService) {
    _authService.observeAuthState().listen(
      (firebaseUser) {
        if (firebaseUser == null) {
          _userDataController.add(null);
        }
      },
      onError: (_) {
        // auth state errors don't affect the user data stream
      },
    );
  }

  @override
  Future<bool> signIn(String email, String password) async {
    return await _authService.signIn(email, password) != null;
  }

  @override
  Future<void> signOut(String? entityId) => _authService.signOut(entityId);

  @override
  Future<bool> isSessionValid() => _authService.isSessionValid();

  @override
  Future<void> reauthenticateUser(String password) => _authService.reauthenticateUser(password);

  @override
  Future<void> changePassword(String password) => _authService.changePassword(password);

  @override
  Future<void> resetPassword(String email) => _authService.resetPassword(email);

  @override
  Future<UserData?> getUserData() {
    return _authService.getUserData();
  }

  @override
  Stream<UserData?> observeUserData() => _userDataController.stream;

  @override
  void notifyUserDataChanged(UserData? userData) {
    _userDataController.add(userData);
  }

  @override
  Future<bool> shouldShowOnboardingForUiChanges(String entityId) {
    return _entityService.shouldShowOnboardingForUiChanges(entityId);
  }

  @override
  Future<void> removeOnboardingForUiChangesFlag(String entityId) {
    return _entityService.removeOnboardingForUiChangesFlag(entityId);
  }

  @override
  Future<void> updateDeviceInfo({
    required String entityId,
    required String deviceId,
    required String appVersion,
    required String buildNumber,
    required String platform,
  }) {
    return _entityService.updateDeviceInfo(
      entityId: entityId,
      deviceId: deviceId,
      appVersion: appVersion,
      buildNumber: buildNumber,
      platform: platform,
    );
  }
}
