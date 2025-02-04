import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/features/appConfiguration/data/entity/remote_app_configuration_dto.dart';
import 'package:zachranobed/features/appConfiguration/data/mapper/app_config_mapper.dart';
import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/features/forceupdate/domain/model/app_config.dart';
import 'package:zachranobed/services/configuration_service.dart';

class FirebaseAppConfigurationRepository implements AppConfigurationRepository {
  final ConfigurationService _configurationService;

  FirebaseAppConfigurationRepository(
    this._configurationService,
  );

  final _collection = FirebaseFirestore.instance
      .collection('appConfiguration')
      .doc('app-terms')
      .withConverter(fromFirestore: (snapshot, _) {
    final json = snapshot.data() ?? {};

    // Mapping to correct property name (`RemoteAppConfigurationDto.lastAppTermsVersion`)
    json['lastAppTermsVersion'] = snapshot['lastVersion'];

    return RemoteAppConfigurationDto.fromJson(json);
  }, toFirestore: (value, options) {
    // Should not be used. THe value should be set manually from remote only if the version of terms changes
    return value.toJson();
  });

  @override
  Future<RemoteAppConfigurationDto?> fetchData() async {
    final snapshot = await _collection.get();
    return snapshot.data();
  }

  @override
  Future<AppConfig> getAppConfig() async {
    final dto = await _configurationService.fetchAppConfig();
    if (dto == null) {
      throw Exception('Unable to retrieve application configuration');
    }
    return dto.toDomain();
  }
}
