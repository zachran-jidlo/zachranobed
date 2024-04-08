import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/features/appConfiguration/data/get_last_app_terms_version_use_case.dart';

class CheckIfAppTermsShouldBeShownUseCase {
  final AuthService authService;
  final GetLastAppTermsVersionUseCase _getLastAppTermsVersionUseCase;

  CheckIfAppTermsShouldBeShownUseCase(
      this.authService,
      this._getLastAppTermsVersionUseCase
  );

  Future<bool> checkIfAppTermsShouldBeShown() async {
    int? lastAppTermsVersion = await _getLastAppTermsVersionUseCase.getLastAppTerms();
    var userData = authService.getUserData();

    return userData.then((value) {
      var lastAcceptedVersion = value?.lastAcceptedAppTermsVersion;

      if (lastAcceptedVersion != null && lastAppTermsVersion != null) {
        return lastAppTermsVersion > lastAcceptedVersion;
      } else {
        return true;
      }
    });
  }
}