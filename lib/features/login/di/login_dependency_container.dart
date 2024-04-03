import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/check_if_app_terms_should_be_shown_usecase.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';
import 'package:zachranobed/features/app_terms/domain/set_newest_accepted_app_terms_usecase.dart';
import 'package:zachranobed/features/app_terms/domain/update_current_user_data_use_case.dart';
import 'package:zachranobed/services/auth_service.dart';
import 'package:zachranobed/services/entity_service.dart';

class LoginDependencyContainer {
  const LoginDependencyContainer._();

  static void setup() {
    GetIt.I.registerSingleton(CheckIfDevtoolsAreEnabledUseCase());
  }
}