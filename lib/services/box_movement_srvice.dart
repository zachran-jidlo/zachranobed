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

  Future<DocumentReference<BoxMovement>> addBoxMovement(
      BoxMovement boxMovement) async {
    return await _boxMovementCollection.add(boxMovement);
  }
}
