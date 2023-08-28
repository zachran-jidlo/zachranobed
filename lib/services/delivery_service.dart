import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/delivery.dart';

class DeliveryService {
  final _deliveryCollection =
      FirebaseFirestore.instance.collection('rozvozy').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return Delivery.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  Future<Delivery?> getDelivery(DateTime date, String donorId) async {
    final deliveryQuerySnapshot = await _deliveryCollection
        .where('pickUpFrom', isEqualTo: date)
        .where('donorId', isEqualTo: donorId)
        .get();

    if (deliveryQuerySnapshot.docs.isNotEmpty) {
      return deliveryQuerySnapshot.docs.first.data();
    }
    return null;
  }

  Future<void> updateDeliveryStatus(String id, String state) async {
    await _deliveryCollection.doc(id).update({'state': state});
  }
}
