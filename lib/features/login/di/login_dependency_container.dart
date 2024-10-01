import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/features/login/presentation/screen/bloc/login_bloc.dart';
import 'package:zachranobed/notifiers/delivery_notifier.dart';
import 'package:zachranobed/notifiers/user_notifier.dart';
import 'package:zachranobed/services/auth_service.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());

    GetIt.I.registerFactoryParam<LoginBloc, UserNotifier, DeliveryNotifier>(
      (userNotifier, deliveryNotifier) {
        return LoginBloc(
            authService: GetIt.I<AuthService>(),
            checkIfDevtoolsAreEnabled:
                GetIt.I<CheckIfDevtoolsAreEnabledUseCase>(),
            checkIfAppTermsShouldBeShown:
                GetIt.I<CheckIfAppTermsShouldBeShownUseCase>(),
            userNotifier: userNotifier,
            deliveryNotifier: deliveryNotifier);
      },
    );
  }
}