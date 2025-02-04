import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/dto/appconfig_dto.dart';
import 'package:zachranobed/models/dto/configuration_contacts_dto.dart';

class ConfigurationService {
  final _contactsDocument = FirebaseFirestore.instance
      .collection('appConfiguration')
      .doc('contacts')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return ConfigurationContactsDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  final _appConfigDocument = FirebaseFirestore.instance
      .collection('appConfiguration')
      .doc('app-config')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return AppConfigDto.fromJson(json);
        },
        toFirestore: (value, options) => value.toJson(),
      );

  Future<ConfigurationContactsDto?> fetchContacts() async {
    final snapshot = await _contactsDocument.get();
    return snapshot.data();
  }

  Future<AppConfigDto?> fetchAppConfig() async {
    final snapshot = await _appConfigDocument.get();
    return snapshot.data();
  }
}
