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
  FirebaseUserRepository(this._authService, this._entityService);

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
}
