import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/models/user_data.dart';

class OfferedFoodService {
  final _offeredFoodCollection =
      FirebaseFirestore.instance.collection('offeredFood').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return OfferedFood.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Sets up a Firestore stream to listen for changes in the `offeredFood`
  /// collection, filtering the offered foods based on the establishment ID of
  /// the provided [user] who is either the donor or recipient of the offered
  /// food. It allows optional [limit] parameter for limiting the number of
  /// results and it is also possible to specify an [additionalFilterField] to
  /// filter by and an [additionalFilterValue] that the field must meet.
  ///
  /// Returns a [Stream] that emits a list of [OfferedFood] objects whenever
  /// there is a change in the Firestore collection that matches the specified
  /// criteria.
  Stream<List<OfferedFood>> loggedUserOfferedFoodStream({
    required UserData user,
    int? limit,
    String? additionalFilterField,
    dynamic additionalFilterValue,
  }) {
    var query = _offeredFoodCollection.orderBy('date', descending: true).where(
        Filter.or(Filter('donorId', isEqualTo: user.establishmentId),
            Filter('recipientId', isEqualTo: user.establishmentId)));

    if (limit != null) {
      query = query.limit(limit);
    }

    if (additionalFilterField != null && additionalFilterValue != null) {
      query =
          query.where(additionalFilterField, isEqualTo: additionalFilterValue);
    }

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// Stores provided [offeredFood] object to the Firestore collection.
  ///
  /// Returns a [Future] that completes with a [DocumentReference] to the
  /// newly added food offer in the Firestore collection.
  Future<DocumentReference<OfferedFood>> createOffer(
      OfferedFood offeredFood) async {
    return await _offeredFoodCollection.add(offeredFood);
  }
}
