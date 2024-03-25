import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/login/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/features/login/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/services/auth_service.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());
    GetIt.I.registerFactory<CheckIfAppTermsShouldBeShownUseCase>(
            () => CheckIfAppTermsShouldBeShownUseCase(GetIt.I<AuthService>())
    );
    GetIt.I.registerFactory<SetNewestAcceptedAppTermsUseCase>(
            () => SetNewestAcceptedAppTermsUseCase(GetIt.I<AuthService>())
    );
  }
}