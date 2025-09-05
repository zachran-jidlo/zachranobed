import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());
  }
}
