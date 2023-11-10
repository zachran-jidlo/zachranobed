import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/canteen.dart';

class CanteenService {
  final _canteenCollection =
      FirebaseFirestore.instance.collection('canteens').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Canteen.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Returns a [Future] that completes with a [Canteen] object if a canteen
  /// document with the provided [email] is found in the Firestore collection
  /// and `null` if no canteen is found.
  Future<Canteen?> getCanteenByEmail(String email) async {
    final canteenQuerySnapshot =
        await _canteenCollection.where('email', isEqualTo: email).get();

    if (canteenQuerySnapshot.docs.isNotEmpty) {
      return canteenQuerySnapshot.docs.first.data();
    }
    return null;
  }
}
