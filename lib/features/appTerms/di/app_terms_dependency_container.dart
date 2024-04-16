import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/appConfiguration/data/get_last_app_terms_version_use_case.dart';
import 'package:zachranobed/features/appConfiguration/data/remote_app_configuration_repository.dart';
import 'package:zachranobed/features/appTerms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/features/appTerms/domain/update_current_user_data_use_case.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/entity_service.dart';

class AppTermsDependencyContainer {
  const AppTermsDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<UpdateCurrentUserDataUseCase>(
      () => UpdateCurrentUserDataUseCase(
          GetIt.I<EntityService>(),
          GetIt.I<AuthService>()
      )
    );
    GetIt.I.registerFactory<SetNewestAcceptedAppTermsUseCase>(
      () => SetNewestAcceptedAppTermsUseCase(
        GetIt.I<UpdateCurrentUserDataUseCase>(),
        GetIt.I<GetLastAppTermsVersionUseCase>()
      )
    );
    GetIt.I.registerFactory<RemoteAppConfigurationRepository>(
      () => RemoteAppConfigurationRepository()
    );
    GetIt.I.registerFactory<GetLastAppTermsVersionUseCase>(
      () => GetLastAppTermsVersionUseCase(
        GetIt.I<RemoteAppConfigurationRepository>()
      )
    );
  }
}