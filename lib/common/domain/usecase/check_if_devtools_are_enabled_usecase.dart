import 'package:zachranobed/common/domain/model/project_configuration.dart';

/// Determines whether development tools are enabled.
class CheckIfDevtoolsAreEnabledUseCase {
  final ProjectConfiguration _configuration = ProjectConfiguration.instance;

  bool invoke() {
    switch (_configuration.buildConfiguration) {
      case BuildConfiguration.dev:
      case BuildConfiguration.stage:
        return true;
      case BuildConfiguration.prod:
        return false;
    }
  }
}
