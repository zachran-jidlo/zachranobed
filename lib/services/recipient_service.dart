import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/recipient.dart';

class RecipientService {
  final _recipientCollection =
      FirebaseFirestore.instance.collection('prijemci').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Recipient.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Future<Recipient?> getRecipientByEmail(String email) async {
    final recipientQuerySnapshot =
        await _recipientCollection.where('email', isEqualTo: email).get();

    if (recipientQuerySnapshot.docs.isNotEmpty) {
      return recipientQuerySnapshot.docs.first.data();
    }
    return null;
  }
}
