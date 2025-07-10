import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/features/appConfiguration/domain/usecase/get_last_app_terms_version_use_case.dart';

class CommonDependencyContainer {
  const CommonDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<GetAppTermsStatusUseCase>(
      () => GetAppTermsStatusUseCase(
        GetIt.I<GetLastAppTermsVersionUseCase>(),
      ),
    );

    GetIt.I.registerSingleton(AppPreferences());
  }
}
