import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/user_data.dart';

class DeliveryService {
  final _collection =
      FirebaseFirestore.instance.collection('deliveries').withConverter(
    fromFirestore: (snapshot, options) {
      final json = snapshot.data() ?? {};
      json['id'] = snapshot.id;
      return DeliveryDto.fromJson(json);
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
    // TODO: Add DeliveryDto to Delivery mapping and return correct instance
    // final deliveryQuerySnapshot = await _collection
    //     .where('pickUpFrom', isEqualTo: date)
    //     .where('donorId', isEqualTo: donorId)
    //     .get();
    //
    // if (deliveryQuerySnapshot.docs.isNotEmpty) {
    //   return deliveryQuerySnapshot.docs.first.data();
    // }
    return null;
  }

  /// Updates the 'state' field of a delivery document identified by the
  /// specified [id] with the provided [state] value.
  Future<void> updateDeliveryStatus(String id, String state) async {
    await _collection.doc(id).update({'state': state});
  }

  /// Queries the Firestore collection for deliveries based on the entity ID
  /// of the provided [user] who is either the donor or recipient of the
  /// offered food. It allows an optional parameter for specifying a
  /// [timePeriod] to filter the results.
  ///
  /// Returns a [Future] that completes with an [int] representing the total
  /// count of saved meals for the specified [timePeriod] and [user].
  Future<int> getSavedMealsCount({
    required UserData user,
    int? timePeriod,
  }) async {
    var mealsCount = 0;

    var query = _collection.where(
      Filter.and(
        Filter.or(
          Filter('donorId', isEqualTo: user.entityId),
          Filter('recipientId', isEqualTo: user.entityId),
        ),
        Filter(
          'state',
          whereIn: [
            DeliveryStateDto.offered.toJson(),
            DeliveryStateDto.accepted.toJson(),
            DeliveryStateDto.inDelivery.toJson(),
            DeliveryStateDto.delivered.toJson(),
          ],
        ),
      ),
    );

    if (timePeriod != null) {
      query = query.where(
        'deliveryDate',
        isGreaterThan: DateTime.now().subtract(Duration(days: timePeriod)),
      );
    }

    final snapshot = await query.get();

    final deliveries = snapshot.docs.map((doc) => doc.data()).toList();
    for (var delivery in deliveries) {
      mealsCount += delivery.meals.fold(0, (inc, e) => inc + e.count);
    }

    return mealsCount;
  }
}
