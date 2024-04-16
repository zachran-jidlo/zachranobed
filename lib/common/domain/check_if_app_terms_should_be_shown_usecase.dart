import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/features/appConfiguration/data/get_last_app_terms_version_use_case.dart';

class CheckIfAppTermsShouldBeShownUseCase {
  // TODO: - Do not use AuthService directly - it should be contained in repository
  // Will be resolved in [ZOB-160](https://etnetera.atlassian.net/browse/ZOB-160)
  final AuthService authService;
  final GetLastAppTermsVersionUseCase _getLastAppTermsVersionUseCase;

  CheckIfAppTermsShouldBeShownUseCase(
      this.authService,
      this._getLastAppTermsVersionUseCase
  );

  Future<bool> invoke() async {
    final lastAppTermsVersion = await _getLastAppTermsVersionUseCase.getLastAppTerms();
    final userData = await authService.getUserData();
    final lastAcceptedVersion = userData?.lastAcceptedAppTermsVersion;

    if (lastAcceptedVersion != null && lastAppTermsVersion != null) {
      return lastAppTermsVersion > lastAcceptedVersion;
    } else {
      return true;
    }
  }
}