import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/repository/auth_repository.dart';
import 'package:zachranobed/common/domain/usecase/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/features/login/domain/usecase/change_password_usecase.dart';
import 'package:zachranobed/features/login/domain/usecase/reset_password_usecase.dart';
import 'package:zachranobed/features/login/domain/usecase/sign_in_usecase.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());
    GetIt.I.registerFactory<SignInUseCase>(() => SignInUseCase(GetIt.I<AuthRepository>()));
    GetIt.I.registerFactory<ChangePasswordUseCase>(() => ChangePasswordUseCase(GetIt.I<AuthRepository>()));
    GetIt.I.registerFactory<ResetPasswordUseCase>(() => ResetPasswordUseCase(GetIt.I<AuthRepository>()));
  }
}
