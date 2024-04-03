import 'package:zachranobed/features/app_terms/domain/update_current_user_data_use_case.dart';
import 'package:zachranobed/services/auth_service.dart';

class SetNewestAcceptedAppTermsUseCase {
  final UpdateCurrentUserDataUseCase updateCurrentUserDataUseCase;
  final AuthService authService;

  SetNewestAcceptedAppTermsUseCase(this.updateCurrentUserDataUseCase, this.authService);

  Future<void> setNewestAcceptedAppTerms() async {
    // FIXME: - Add actual value fetching
    int lastAppTermsVersion = 1;

    updateCurrentUserDataUseCase.updateCurrentUserData({
      "lastAcceptedAppTermsVersion": lastAppTermsVersion
    });
  }
}