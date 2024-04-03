import 'package:zachranobed/services/auth_service.dart';

class CheckIfAppTermsShouldBeShownUseCase {
  final AuthService authService;

  CheckIfAppTermsShouldBeShownUseCase(this.authService);

  Future<bool> checkIfAppTermsShouldBeShown() async {
    // FIXME: - Add actual value fetching
    int lastAppTermsVersion = 1;
    var userData = authService.getUserData();

    return userData.then((value) {
      var lastAcceptedVersion = value?.lastAcceptedAppTermsVersion;

      if (lastAcceptedVersion != null) {
        return lastAcceptedVersion > lastAppTermsVersion;
      } else {
        return true;
      }
    });
  }
}