import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_if_upgrade_app_should_be_shown_usecase.dart';
import 'package:zachranobed/features/login/domain/check_if_devtools_are_enabled_usecase.dart';

class ForceUpdateDependencyContainer {
  const ForceUpdateDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<CheckIfUpgradeAppShouldBeShownUseCase>(
          () => CheckIfUpgradeAppShouldBeShownUseCase(
        GetIt.I<AppConfigurationRepository>(),
      ),
    );
  }
}