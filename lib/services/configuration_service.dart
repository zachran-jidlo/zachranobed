import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<ConfigurationContactsDto?> fetchContacts() async {
    final snapshot = await _contactsDocument.get();
    return snapshot.data();
  }
}
