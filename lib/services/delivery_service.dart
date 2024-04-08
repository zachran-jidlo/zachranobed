import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/firestore_utils.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';

class DeliveryService {
  /// Valid states for delivery items in history.
  final List<String> _validHistoryStates = [
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

  /// Returns a [Future] that completes with a [DeliveryDto] object if a
  /// delivery with the provided [time] and [donorId] is found in the Firestore
  /// collection and `null` if no delivery is found with the specified
  /// criteria.
  Future<DeliveryDto?> getDelivery(String donorId, DateTime time) async {
    final deliveryQuerySnapshot = await _collection
        .where('donorId', isEqualTo: donorId)
        .where('type', isEqualTo: DeliveryTypeDto.foodDelivery.toJson())
        .whereTime('pickupTimeWindow.start', time)
        .get();

    if (deliveryQuerySnapshot.docs.isNotEmpty) {
      return deliveryQuerySnapshot.docs.first.data();
    }
    return null;
  }

  /// Updates the 'state' field of a delivery document identified by the
  /// specified [id] with the provided [state] value.
  Future<bool> updateDeliveryState(String id, DeliveryStateDto state) async {
    return await _collection.doc(id).update({'state': state.toJson()}).then(
      (value) => true,
      onError: (error) => false,
    );
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

  /// Adds [meals] to the delivery with given [id]. Then recalculates foodboxes
  /// for the same delivery. Returns a future with true when operation succeeds
  /// and false otherwise.
  Future<bool> addMealsAndBoxes(String id, Iterable<MealDto> meals) async {
    final addMeals = await _collection.doc(id).update({
      'meals': FieldValue.arrayUnion(
        meals.map((e) => e.toJson()).toList(),
      )
    }).then(
      (value) => true,
      onError: (error) => false,
    );

    if (!addMeals) {
      return false;
    }

    final delivery = (await _collection.doc(id).get()).data();
    final Map<String, int> foodBoxesCount = {};
    for (final meal in (delivery?.meals ?? List<MealDto>.empty())) {
      final acc = (foodBoxesCount[meal.foodBoxId] ?? 0) + meal.foodBoxCount;
      foodBoxesCount[meal.foodBoxId] = acc;
    }

    final foodBoxes = foodBoxesCount.entries.map(
      (e) => FoodBoxDeliveryDto(
        foodBoxId: e.key,
        count: e.value,
      ).toJson(),
    );

    return _collection.doc(id).update({'foodBoxes': foodBoxes.toList()}).then(
      (value) => true,
      onError: (error) => false,
    );
  }

  /// Creates a delivery from the given [dto] instance.
  /// Returns a future with true when operation succeeds and false otherwise.
  Future<bool> createDelivery(DeliveryDto dto) {
    return _collection //
        .doc(dto.id)
        .set(dto)
        .then(
      (value) => true,
      onError: (error) => false,
    );
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
        whereIn: _validHistoryStates,
      ),
    );
  }
}
