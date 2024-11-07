import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/features/appConfiguration/data/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/services/auth_service.dart';

class CommonDependencyContainer {
  const CommonDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<CheckIfAppTermsShouldBeShownUseCase>(
      () => CheckIfAppTermsShouldBeShownUseCase(
        GetIt.I<AuthService>(),
        GetIt.I<GetLastAppTermsVersionUseCase>(),
      ),
    );

    GetIt.I.registerSingleton(AppPreferences());
  }
}
