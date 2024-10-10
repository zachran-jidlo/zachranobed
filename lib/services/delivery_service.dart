import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:zachranobed/common/utils/firestore_utils.dart';
import 'package:zachranobed/common/utils/future_utils.dart';
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

  /// Observes a delivery for a specific donor at a specific time.
  ///
  /// This method sets up a Firestore stream to listen for changes in the
  /// `deliveries` collection. It filters deliveries based on the provided
  /// [donorId], type and last midnight timestamp to get "today's" delivery.
  ///
  /// The [donorId] parameter is the ID of the donor whose delivery is to be
  /// observed.
  ///
  /// The method returns a `Stream` of `DeliveryDto?`. Each `DeliveryDto?` in
  /// the `Stream` represents a delivery for the donor. The `Stream` emits a new
  /// `DeliveryDto?` whenever there is a change in the delivery for the donor.
  ///
  /// The `where` method is used to filter the deliveries based on the donor ID,
  /// the type of the delivery, and the time of the last midnight timestamp.
  /// The `snapshots` method is used to listen for changes in the `deliveries`
  /// collection.
  /// The `map` method is used to transform the snapshots into  `DeliveryDto?`
  /// objects.
  Stream<DeliveryDto?> observeDelivery(String donorId) {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final snapshots = _collection
        .where('donorId', isEqualTo: donorId)
        .where('type', isEqualTo: DeliveryTypeDto.foodDelivery.toJson())
        .whereTime('deliveryDate', lastMidnight)
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.firstOrNull?.data());
  }

  /// Returns a [Future] that completes with a [DeliveryDto] object with a
  /// given [deliveryId].
  Future<DeliveryDto?> getDeliveryById(String deliveryId) async {
    final snapshot = await _collection
        .doc(deliveryId)
        .get(const GetOptions(source: Source.server));
    return snapshot.data();
  }

  /// Updates the 'state' field of a delivery document identified by the
  /// specified [id] with the provided [state] value.
  Future<bool> updateDeliveryState(String id, DeliveryStateDto state) async {
    return await _collection
        .doc(id)
        .update({'state': state.toJson()}).toSuccess();
  }

  /// Queries the Firestore collection for deliveries of the given pair defined
  /// by [donorId] and [recipientId] of the offered food. It allows an optional
  /// parameter for specifying a [timePeriod] to filter the results.
  Future<Iterable<DeliveryDto>> getDeliveries({
    required String donorId,
    required String recipientId,
    int? timePeriod,
  }) async {
    var query = _collection.where(_hasEntity(donorId, recipientId));

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
  /// collection, filtering deliveries based on the provided pair of [donorId]
  /// and [recipientId].
  ///
  /// Additional parameters may be used to filter response. Specify [limit] to
  /// return as much deliveries from Firestore. Use [from] to filter items
  /// delivered after (including) this date. Use [to] to filter items
  /// delivered before (excluding) this date.
  Stream<Iterable<DeliveryDto>> observeDeliveries({
    required String donorId,
    required String recipientId,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) {
    var query = _collection
        .orderBy('deliveryDate', descending: true)
        .where(_hasEntity(donorId, recipientId));

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
    }).toSuccess();

    if (!addMeals) {
      return false;
    }

    final delivery = await getDeliveryById(id);
    final Map<String, int> foodBoxesCount = {};
    for (final meal in (delivery?.meals ?? List<MealDto>.empty())) {
      final acc = (foodBoxesCount[meal.foodBoxId] ?? 0) + meal.foodBoxCount;
      foodBoxesCount[meal.foodBoxId] = acc;
    }

    final foodBoxes = foodBoxesCount.entries.map(
      (e) => FoodBoxDeliveryDto(
        foodBoxId: e.key,
        count: e.value,
      ),
    );

    return updateDeliveryFoodboxes(id, foodBoxes.toList());
  }

  /// Creates a delivery from the given [dto] instance.
  /// Returns a future with true when operation succeeds and false otherwise.
  Future<bool> createDelivery(DeliveryDto dto) {
    return _collection //
        .doc(dto.id)
        .set(dto)
        .toSuccess();
  }

  /// Updates foodboxes in a delivery with a given [id].
  /// Returns a future with true when operation succeeds and false otherwise.
  Future<bool> updateDeliveryFoodboxes(
    String id,
    List<FoodBoxDeliveryDto> foodBoxes,
  ) {
    return _collection //
        .doc(id)
        .update({'foodBoxes': foodBoxes.map((e) => e.toJson())}).toSuccess();
  }

  /// Prepares a filter to get only deliveries of the offered food for the given
  /// [donorId] and [recipientId]. Also filters deliveries with only valid
  /// (offered, accepted, in-delivery and delivered) states.
  Filter _hasEntity(String donorId, String recipientId) {
    return Filter.and(
      Filter.and(
        Filter('donorId', isEqualTo: donorId),
        Filter('recipientId', isEqualTo: recipientId),
      ),
      Filter(
        'state',
        whereIn: _validHistoryStates,
      ),
    );
  }
}
