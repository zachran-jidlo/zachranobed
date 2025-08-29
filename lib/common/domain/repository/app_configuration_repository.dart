import 'package:zachranobed/common/domain/model/app_config.dart';
import 'package:zachranobed/common/domain/model/app_terms_config.dart';

/// Repository to application configuration.
abstract class AppConfigurationRepository {
  /// Fetches the application configuration.
  Future<AppConfig> getAppConfig();

  /// Fetches the configuration for application terms and conditions.
  Future<AppTermsConfig> getAppTermsConfig();
}
