import 'package:zachranobed/features/forceupdate/domain/model/app_config.dart';

import '../../data/entity/remote_app_configuration_dto.dart';

/// Repository to application configuration.
abstract class AppConfigurationRepository {
  /// Fetches remote application configuration.
  Future<RemoteAppConfigurationDto?> fetchData();

  /// Fetches all application configuration.
  Future<AppConfig> getAppConfig();
}
