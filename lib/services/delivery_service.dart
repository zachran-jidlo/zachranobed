import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/delivery.dart';

class DeliveryService {
  final _deliveryCollection =
      FirebaseFirestore.instance.collection('deliveries').withConverter(
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

  ///  Returns a [Future] that completes with a [Delivery] object if a delivery
  ///  with the provided [date] and [donorId] is found in the Firestore
  ///  collection and `null` if no delivery is found with the specified
  ///  criteria.
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

  /// Updates the 'state' field of a delivery document identified by the
  /// specified [id] with the provided [state] value.
  Future<void> updateDeliveryStatus(String id, String state) async {
    await _deliveryCollection.doc(id).update({'state': state});
  }
}
