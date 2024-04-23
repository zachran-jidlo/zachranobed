import 'package:zachranobed/features/appConfiguration/data/remote_app_configuration_repository.dart';

class GetLastAppTermsVersionUseCase {
  final RemoteAppConfigurationRepository _remoteAppConfigurationRepository;

  GetLastAppTermsVersionUseCase(this._remoteAppConfigurationRepository);

  Future<int?> getLastAppTerms() async {
    var data = await _remoteAppConfigurationRepository.fetchData();

    return data?.lastAppTermsVersion;
  }
}