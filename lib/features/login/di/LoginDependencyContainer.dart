import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/login/domain/CheckIfDevtoolsAreEnabledUseCase.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());
  }
}