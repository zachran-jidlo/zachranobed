import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/box_movement.dart';
import 'package:zachranobed/models/user_data.dart';

class BoxMovementService {
  final _boxMovementCollection =
      FirebaseFirestore.instance.collection('boxMovement').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return BoxMovement.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Stores provided [boxMovement] object to the Firestore collection.
  ///
  /// Returns a [Future] that completes with a [DocumentReference] to the
  /// newly added box movement in the Firestore collection.
  Future<DocumentReference<BoxMovement>> addBoxMovement(
      BoxMovement boxMovement) async {
    return await _boxMovementCollection.add(boxMovement);
  }
}
