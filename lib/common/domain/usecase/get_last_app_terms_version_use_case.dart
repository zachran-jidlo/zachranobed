import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';

/// A use case that retrieves the latest version of the application's terms and conditions.
class GetLastAppTermsVersionUseCase {
  final AppConfigurationRepository _appConfigurationRepository;

  GetLastAppTermsVersionUseCase(this._appConfigurationRepository);

  Future<int?> getLastAppTerms() async {
    final config = await _appConfigurationRepository.getAppTermsConfig();

    return config.lastVersion;
  }
}
