import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/dto/entity_pair_dto.dart';

class EntityPairService {
  final _collection =
      FirebaseFirestore.instance.collection('entityPairs').withConverter(
            fromFirestore: (snapshot, _) =>
                EntityPairDto.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toJson(),
          );

  /// Returns a [Future] that completes with a list of [EntityPairDto] objects
  /// if an entity pairs document with the provided [donorId] is found in
  /// the Firestore collection and `null` if no entity pairs is found.
  Future<List<EntityPairDto>?> getByDonorId(String donorId) async {
    final snapshot = await _collection
        .where(
          'donorId',
          isEqualTo: donorId,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((e) => e.data()).toList();
    }
    return null;
  }

  /// Returns a [Future] that completes with a list of [EntityPairDto] objects
  /// if an entity pairs document with the provided [recipientId] is found in
  /// the Firestore collection and `null` if no entity pairs is found.
  Future<List<EntityPairDto>?> getByRecipientId(String recipientId) async {
    final snapshot = await _collection
        .where(
          'recipientId',
          isEqualTo: recipientId,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((e) => e.data()).toList();
    }
    return null;
  }
}
