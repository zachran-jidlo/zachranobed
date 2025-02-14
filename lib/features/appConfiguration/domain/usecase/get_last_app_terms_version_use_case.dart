import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';

class GetLastAppTermsVersionUseCase {
  final AppConfigurationRepository _appConfigurationRepository;

  GetLastAppTermsVersionUseCase(this._appConfigurationRepository);

  Future<int?> getLastAppTerms() async {
    var data = await _appConfigurationRepository.fetchData();

    return data?.lastAppTermsVersion;
  }
}