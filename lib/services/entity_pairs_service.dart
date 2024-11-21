import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/utils/future_utils.dart';
import 'package:zachranobed/models/canteen.dart';
import 'package:zachranobed/models/charity.dart';
import 'package:zachranobed/models/dto/entity_pair_dto.dart';
import 'package:zachranobed/models/dto/food_box_pair_dto.dart';
import 'package:zachranobed/models/user_data.dart';

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

  /// Returns a [Future] that completes with a list of [EntityPairDto] objects
  /// for the given [user], or `null` if no entity pairs are found.
  Future<List<EntityPairDto>?> getByUser(UserData user) async {
    if (user is Canteen) {
      return getByDonorId(user.entityId);
    } else if (user is Charity) {
      return getByRecipientId(user.entityId);
    }
    return null;
  }

  /// Sets up a Firestore stream to listen for changes in the `entityPairs`
  /// collection, filtering the only pair based on the provided [donorId] and
  /// [recipientId].
  ///
  /// Returns a [Stream] that emits a list of [EntityPairDto] objects whenever
  /// there is a change in the Firestore collection that matches the specified
  /// criteria.
  Stream<EntityPairDto?> observePair({
    required String donorId,
    required String recipientId,
  }) {
    final query = _collection.where(
      Filter.and(
        Filter('donorId', isEqualTo: donorId),
        Filter('recipientId', isEqualTo: recipientId),
      ),
    );

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    });
  }

  /// Moves food boxes from [donorId] to [recipientId]. This method should be
  /// called when canteen donates a food, and as a result food boxes statistics
  /// should be updated. The [changeMap] contains a map with newly added
  /// food boxes to a delivery.
  Future<bool> moveBoxesToRecipient({
    required String donorId,
    required String recipientId,
    required Map<String, int> changeMap,
  }) =>
      _moveBoxes(donorId, recipientId, changeMap);

  /// Moves food boxes from [recipientId] to [donorId]. This method should be
  /// called when charity orders a box delivery, and as a result food boxes
  /// statistics should be updated. The [changeMap] contains a map with newly
  /// added food boxes to a delivery.
  Future<bool> moveBoxesToDonor({
    required String donorId,
    required String recipientId,
    required Map<String, int> changeMap,
  }) {
    // Reverse counts sign to subtract the count from recipient and add to donor
    final map = changeMap.map((key, value) => MapEntry(key, -value));
    return _moveBoxes(donorId, recipientId, map);
  }

  Future<bool> _moveBoxes(
    String donorId,
    String recipientId,
    Map<String, int> changeMap,
  ) async {
    // Get reference to current document
    final reference = await _getPairDocument(donorId, recipientId);
    if (reference == null) {
      return false;
    }

    // Get current document data
    final pairDocument = await reference.get();
    final pair = pairDocument.data();
    if (pair == null) {
      return false;
    }

    // Update food boxes according to changeMap
    final newFoodBoxes = pair.foodboxes.map((element) {
      final changeCount = changeMap[element.foodBoxId] ?? 0;
      return FoodBoxPairDto(
        foodBoxId: element.foodBoxId,
        count: element.count,
        donorCount: element.donorCount - changeCount,
        recipientCount: element.recipientCount + changeCount,
      );
    });

    // Update 'foodboxes' list with a new value
    return reference
        .update({'foodboxes': newFoodBoxes.map((e) => e.toJson())}).toSuccess();
  }

  Future<DocumentReference<EntityPairDto>?> _getPairDocument(
    String donorId,
    String recipientId,
  ) async {
    final snapshot = await _collection
        .where(
          Filter.and(
            Filter('donorId', isEqualTo: donorId),
            Filter('recipientId', isEqualTo: recipientId),
          ),
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.reference;
    }

    return null;
  }
}
