import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/dto/entity_dto.dart';

class EntityService {
  final _collection =
      FirebaseFirestore.instance.collection('entities').withConverter(
    fromFirestore: (snapshot, _) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return EntityDto.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Returns a [Future] that completes with a [EntityDto] object if an entity
  /// document with the provided [email] is found in the Firestore collection
  /// and `null` if no entity is found.
  Future<EntityDto?> getEntityByEmail(String email) async {
    final snapshot = await _collection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }
}
