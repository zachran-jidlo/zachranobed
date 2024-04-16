import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/entity_service.dart';

class UpdateCurrentUserDataUseCase {
  final AuthService _authService;
  final EntityService _entityService;

  UpdateCurrentUserDataUseCase(this._entityService, this._authService);

  Future<void> updateLastAcceptedAppTermsVersion(int lastAppTermsVersion) async {
    final userData = await _authService.getUserData();

    if (userData != null) {
      _entityService.saveAppTermsVersion(userData.entityId, lastAppTermsVersion);
    } else {
      ZOLogger.logMessage("UID for the current user has not been found. The user is most probably not logged in.");
    }
  }
}