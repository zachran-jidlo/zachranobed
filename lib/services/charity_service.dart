import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/charity.dart';

class CharityService {
  final _charityCollection =
      FirebaseFirestore.instance.collection('charities').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Charity.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Returns a [Future] that completes with a [Charity] object if a charity
  /// document with the provided [email] is found in the Firestore collection
  /// and `null` if no charity is found.
  Future<Charity?> getCharityByEmail(String email) async {
    final charityQuerySnapshot =
        await _charityCollection.where('email', isEqualTo: email).get();

    if (charityQuerySnapshot.docs.isNotEmpty) {
      return charityQuerySnapshot.docs.first.data();
    }
    return null;
  }
}
