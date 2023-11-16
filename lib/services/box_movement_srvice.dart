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

  /// Sets up a Firestore stream to listen for changes in the `boxMovement`
  /// collection, filtering the box movements based on the establishment ID of
  /// the provided [user] who is either the sender or recipient in the box
  /// movement and the specified [weekNumber] when the box movements occurred.
  ///
  /// Retruns a [Stream] that emits a list of [BoxMovement] objects whenever
  /// there is a change in the Firestore collection that matches the specified
  /// criteria.
  Stream<List<BoxMovement>> loggedUserBoxMovementStream({
    required UserData user,
    required String weekNumber,
  }) {
    final query = _boxMovementCollection
        .orderBy('date', descending: true)
        .where(Filter.or(Filter('senderId', isEqualTo: user.establishmentId),
            Filter('recipientId', isEqualTo: user.establishmentId)))
        .where('weekNumber', isEqualTo: weekNumber);

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  /// Stores provided [boxMovement] object to the Firestore collection.
  ///
  /// Returns a [Future] that completes with a [DocumentReference] to the
  /// newly added box movement in the Firestore collection.
  Future<DocumentReference<BoxMovement>> addBoxMovement(
      BoxMovement boxMovement) async {
    return await _boxMovementCollection.add(boxMovement);
  }
}
