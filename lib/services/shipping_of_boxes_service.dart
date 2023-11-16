import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/shipping_of_boxes.dart';

class ShippingOfBoxesService {
  final _shippingOfBoxesCollection =
      FirebaseFirestore.instance.collection('shippingOfBoxes').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return ShippingOfBoxes.fromJson(json);
    },
    toFirestore: (value, options) {
      final json = value.toJson();
      json.remove('id');
      return json;
    },
  );

  /// Stores provided [shipping] object to the Firestore collection.
  Future<void> createShippingOfBoxes(ShippingOfBoxes shipping) async {
    await _shippingOfBoxesCollection.add(shipping);
  }
}
