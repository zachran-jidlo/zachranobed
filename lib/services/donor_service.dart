import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/user_data.dart';

class DonorService {
  final _donorCollection =
      FirebaseFirestore.instance.collection('darci').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return UserData.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Future<UserData?> getDonorByEmail(String email) async {
    final donorQuerySnapshot =
        await _donorCollection.where('email', isEqualTo: email).get();

    if (donorQuerySnapshot.docs.isNotEmpty) {
      return donorQuerySnapshot.docs.first.data();
    }
    return null;
  }
}
