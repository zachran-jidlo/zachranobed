import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/features/appConfiguration/data/entity/remote_app_configuration_dto.dart';

class RemoteAppConfigurationRepository {
  final _collection = FirebaseFirestore.instance.collection('appConfiguration').doc('app-terms').withConverter(
      fromFirestore: (snapshot, _) {
        final json = snapshot.data() ?? {};
        json['id'] = snapshot.id;

        // Mapping to correct property name (`RemoteAppConfigurationDto.lastAppTermsVersion`)
        json['lastAppTermsVersion'] = snapshot['lastVersion'];

        return RemoteAppConfigurationDto.fromJson(json);
      },
      toFirestore: (value, options) {
        // Should not be used. THe value should be set manually from remote only if the version of terms changes
        return value.toJson();
      }
  );

  Future<RemoteAppConfigurationDto?> fetchData() async {
    final snapshot = await _collection.get();
    return snapshot.data();
  }
}