import 'package:zachranobed/services/auth_service.dart';

class CheckIfAppTermsShouldBeShownUseCase {
  final AuthService authService;

  CheckIfAppTermsShouldBeShownUseCase(this.authService);

  Future<bool> checkIfAppTermsShouldBeShown() async {
    // FIXME: - Add actual value fetching
    int lastAppTermsVersion = 1;
    var userData = authService.getUserData();

    // FIXME: - this should access the value `lastAcceptedAppTermsVersion` and compare it to the `lastAppTermsVersion`
    // FIXME: - Remove mock
    //return userData.then((value) => value?.email != null);
    return Future.delayed(Duration(seconds: 1), () => true);
  }
}