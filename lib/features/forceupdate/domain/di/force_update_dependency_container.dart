import 'package:get_it/get_it.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_if_upgrade_app_should_be_shown_usecase.dart';
import 'package:zachranobed/features/forceupdate/domain/usecase/check_web_soft_update_should_be_shown_usecase.dart';

class ForceUpdateDependencyContainer {
  const ForceUpdateDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<CheckIfUpgradeAppShouldBeShownUseCase>(
      () => CheckIfUpgradeAppShouldBeShownUseCase(
        GetIt.I<AppConfigurationRepository>(),
        GetIt.I<GetAppSemanticVersionUseCase>(),
      ),
    );
    GetIt.I.registerFactory<CheckWebSoftUpdateShouldBeShownUseCase>(
      () => CheckWebSoftUpdateShouldBeShownUseCase(
        GetIt.I<AppConfigurationRepository>(),
        GetIt.I<GetAppSemanticVersionUseCase>(),
      ),
    );
  }
}
