import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/appConfiguration/data/repository/firebase_app_configuration_repository.dart';
import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/services/configuration_service.dart';

class AppConfigurationDependencyContainer {
  const AppConfigurationDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<AppConfigurationRepository>(() =>
        FirebaseAppConfigurationRepository(GetIt.I<ConfigurationService>()));
  }
}