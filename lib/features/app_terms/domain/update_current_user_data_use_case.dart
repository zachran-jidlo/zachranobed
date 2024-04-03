import 'package:firebase_auth/firebase_auth.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/services/entity_service.dart';

class UpdateCurrentUserDataUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EntityService entityService;

  UpdateCurrentUserDataUseCase(this.entityService);

  Future<void> updateCurrentUserData(Map<Object, Object?> data) async {
    var currentUserEmail = _auth.currentUser?.email;
    if (currentUserEmail != null) {
      entityService.updateEntityDataWithEmail(currentUserEmail, data);
    } else {
      ZOLogger.logMessage("Email for the current user has not been found. The user is most probably not logged in.");
    }
  }
}