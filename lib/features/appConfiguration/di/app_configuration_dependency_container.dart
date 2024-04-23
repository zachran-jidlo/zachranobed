import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/appConfiguration/data/remote_app_configuration_repository.dart';

class AppConfigurationDependencyContainer {
  const AppConfigurationDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory(RemoteAppConfigurationRepository() as FactoryFunc<Object>);
  }
}