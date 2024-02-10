import 'package:zachranobed/features/appConfiguration/AppConfiguration.dart';
import 'package:zachranobed/features/appConfiguration/entity/BuildConfiguration.dart';

class CheckIfDevtoolsAreEnabledUseCase {
  AppConfiguration _appConfiguration = AppConfiguration.instance;

  bool checkIfDevtoolsAreEnabled() {
    switch (_appConfiguration.buildConfiguration) {
      case BuildConfiguration.dev:
      case BuildConfiguration.stage:
        return true;
      case BuildConfiguration.prod:
        return false;
    }
  }
}