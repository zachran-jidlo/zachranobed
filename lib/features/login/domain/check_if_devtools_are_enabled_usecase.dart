import 'package:zachranobed/features/appConfiguration/app_configuration.dart';
import 'package:zachranobed/features/appConfiguration/entity/build_configuration.dart';

class CheckIfDevtoolsAreEnabledUseCase {
  final AppConfiguration _appConfiguration = AppConfiguration.instance;

  bool invoke() {
    switch (_appConfiguration.buildConfiguration) {
      case BuildConfiguration.dev:
      case BuildConfiguration.stage:
        return true;
      case BuildConfiguration.prod:
        return false;
    }
  }
}