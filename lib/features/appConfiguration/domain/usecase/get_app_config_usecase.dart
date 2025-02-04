import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/features/forceupdate/domain/model/app_config.dart';

/// Use case to get application configuration.
class GetAppConfigUseCase {
  final AppConfigurationRepository _repository;

  GetAppConfigUseCase(this._repository);

  /// Fetches available application configuration.
  Future<AppConfig> invoke() async {
    return await _repository.getAppConfig();
  }
}
