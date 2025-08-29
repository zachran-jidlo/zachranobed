import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/data/repository/firebase_app_configuration_repository.dart';
import 'package:zachranobed/common/data/repository/firebase_user_repository.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_terms_status_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_user_data_usecase.dart';
import 'package:zachranobed/common/prefs/app_preferences.dart';
import 'package:zachranobed/common/domain/usecase/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/configuration_service.dart';

class CommonDependencyContainer {
  const CommonDependencyContainer._();

  static void setup() {
    _setupAppTermsComponents();
    _setupUserComponents();
    _setupAppConfigurationComponents();
    _setupAppPreferencesComponents();
  }

  static void _setupAppTermsComponents() {
    // UseCases
    GetIt.I.registerFactory<GetAppTermsStatusUseCase>(
      () => GetAppTermsStatusUseCase(
        GetIt.I<GetLastAppTermsVersionUseCase>(),
      ),
    );

    GetIt.I.registerFactory<GetLastAppTermsVersionUseCase>(
      () => GetLastAppTermsVersionUseCase(
        GetIt.I<AppConfigurationRepository>(),
      ),
    );
  }

  static void _setupUserComponents() {
    // Repositories
    GetIt.I.registerFactory<UserRepository>(
      () => FirebaseUserRepository(
        GetIt.I<AuthService>(),
      ),
    );

    // UseCases
    GetIt.I.registerFactory<GetUserDataUseCase>(
      () => GetUserDataUseCase(
        GetIt.I<UserRepository>(),
      ),
    );
  }

  static void _setupAppConfigurationComponents() {
    // Repositories
    GetIt.I.registerFactory<AppConfigurationRepository>(
      () => FirebaseAppConfigurationRepository(
        GetIt.I<ConfigurationService>(),
      ),
    );
  }

  static void _setupAppPreferencesComponents() {
    GetIt.I.registerSingleton(AppPreferences());
  }
}
