import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';

class DeliveryService {
  /// Valid states for delivery items.
  final List<String> _validStates = [
    DeliveryStateDto.offered.toJson(),
    DeliveryStateDto.accepted.toJson(),
    DeliveryStateDto.inDelivery.toJson(),
    DeliveryStateDto.delivered.toJson(),
  ];

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
  Future<Iterable<DeliveryDto>> getDeliveries(
    String entityId,
    int? timePeriod,
  ) async {
    var query = _collection.where(_hasEntity(entityId));

    if (timePeriod != null) {
      query = query.where(
        'deliveryDate',
        isGreaterThan: DateTime.now().subtract(Duration(days: timePeriod)),
      );
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data());
  }

  /// Sets up a Firestore stream to listen for changes in the `deliveries`
  /// collection, filtering deliveries based on the provided [entityId] that
  /// belongs to the currently signed in user. The user can be associated
  /// with the [DeliveryDto] either as a `donor` or a `recipient`.
  ///
  /// Additional parameters may be used to filter response. Specify [limit] to
  /// return as much deliveries from Firestore. Use [from] to filter items
  /// delivered after (including) this date. Use [to] to filter items
  /// delivered before (excluding) this date.
  Stream<Iterable<DeliveryDto>> observeDeliveries(
    String entityId,
    int? limit,
    DateTime? from,
    DateTime? to,
  ) {
    var query = _collection
        .orderBy('deliveryDate', descending: true)
        .where(_hasEntity(entityId));

    if (limit != null) {
      query = query.limit(limit);
    }

    if (from != null) {
      query = query.where(
        'deliveryDate',
        isGreaterThanOrEqualTo: from,
      );
    }

    if (to != null) {
      query = query.where(
        'deliveryDate',
        isLessThan: to,
      );
    }

    return query
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => document.data()));
  }

  /// Prepares a filter to get only deliveries where [entityId] is either the
  /// donor or recipient of the offered food. Also filters deliveries with only
  /// valid (offered, accepted, in-delivery and delivered) states.
  Filter _hasEntity(String entityId) {
    return Filter.and(
      Filter.or(
        Filter('donorId', isEqualTo: entityId),
        Filter('recipientId', isEqualTo: entityId),
      ),
      Filter(
        'state',
        whereIn: _validStates,
      ),
    );
  }
}
