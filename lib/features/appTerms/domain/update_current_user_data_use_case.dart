import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/services/entity_service.dart';

class UpdateCurrentUserDataUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EntityService entityService;

  UpdateCurrentUserDataUseCase(this.entityService);

  Future<void> updateLastAcceptedAppTermsVersion(int lastAppTermsVersion) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId != null) {
      entityService.saveAppTermsVersion(currentUserId, lastAppTermsVersion);
    } else {
      ZOLogger.logMessage("UID for the current user has not been found. The user is most probably not logged in.");
    }
  }
}