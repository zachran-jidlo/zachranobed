import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/offered_food.dart';

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

  /// Stores provided [offeredFood] object to the Firestore collection.
  ///
  /// Returns a [Future] that completes with a [DocumentReference] to the
  /// newly added food offer in the Firestore collection.
  Future<DocumentReference<OfferedFood>> createOffer(
      OfferedFood offeredFood) async {
    return await _offeredFoodCollection.add(offeredFood);
  }
}
