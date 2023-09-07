import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/box.dart';

class BoxService {
  final _boxCollection =
      FirebaseFirestore.instance.collection('boxes').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Box.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Stream<List<Box>> loggedUserBoxesStream({required String establishmentId}) {
    final query = _boxCollection.where(Filter.or(
        Filter('charityId', isEqualTo: establishmentId),
        Filter('canteenId', isEqualTo: establishmentId)));

    return query.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }
}
