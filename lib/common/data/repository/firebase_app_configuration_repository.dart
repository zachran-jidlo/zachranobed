import 'package:zachranobed/common/data/mapper/app_config_mapper.dart';
import 'package:zachranobed/common/data/mapper/app_terms_config_mapper.dart';
import 'package:zachranobed/common/domain/model/app_config.dart';
import 'package:zachranobed/common/domain/model/app_terms_config.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/services/configuration_service.dart';

class FirebaseAppConfigurationRepository implements AppConfigurationRepository {
  final ConfigurationService _configurationService;

  FirebaseAppConfigurationRepository(
    this._configurationService,
  );

  @override
  Future<AppConfig> getAppConfig() async {
    final dto = await _configurationService.fetchAppConfig();
    if (dto == null) {
      throw Exception('Unable to retrieve application configuration');
    }
    return dto.toDomain();
  }

  @override
  Future<AppTermsConfig> getAppTermsConfig() async {
    final dto = await _configurationService.fetchAppTermsConfig();
    if (dto == null) {
      throw Exception('Unable to retrieve configuration for application terms and conditions');
    }
    return dto.toDomain();
  }
}
