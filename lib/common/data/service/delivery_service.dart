import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/common/data/dto/meal_dto.dart';
import 'package:zachranobed/common/data/utils/firestore_utils.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/domain/utils/future_utils.dart';

class DeliveryService {
  /// Valid states for delivery items in history.
  final List<String> _validHistoryStates = [
    DeliveryStateDto.accepted.toJson(),
    DeliveryStateDto.onWayToPickUp.toJson(),
    DeliveryStateDto.inDelivery.toJson(),
    DeliveryStateDto.delivered.toJson(),
    DeliveryStateDto.done.toJson(),
  ];

  final _collection = FirebaseFirestore.instance.collection('deliveries').withConverter(
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
  /// [donorId] & [recipientId] pair, type and last midnight timestamp to get
  /// "today's" delivery.
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
  Stream<DeliveryDto?> observeDelivery({
    required String donorId,
    required String recipientId,
  }) {
    final snapshots = _collection
        .where('donorId', isEqualTo: donorId)
        .where('recipientId', isEqualTo: recipientId)
        .where('type', isEqualTo: DeliveryTypeDto.foodDelivery.toJson())
        .whereTime('deliveryDate', DateTimeUtils.lastMidnight())
        .snapshots();
    return snapshots.map((snapshot) => snapshot.docs.firstOrNull?.data());
  }

  /// Returns a [Future] that completes with a [DeliveryDto] object with a
  /// given [deliveryId].
  Future<DeliveryDto?> getDeliveryById(String deliveryId) async {
    final snapshot = await _collection.doc(deliveryId).get(const GetOptions(source: Source.server));
    return snapshot.data();
  }

  /// Observes a specific delivery by its ID.
  ///
  /// This method sets up a Firestore stream to listen for changes in a
  /// specific delivery document. Returns a `Stream` of `DeliveryDto?` that
  /// emits whenever the delivery document changes.
  Stream<DeliveryDto?> observeDeliveryById(String deliveryId) {
    return _collection.doc(deliveryId).snapshots().map((snapshot) => snapshot.data());
  }

  /// Updates the 'state' field of a delivery document identified by the
  /// specified [id] with the provided [state] value.
  Future<bool> updateDeliveryState(String id, DeliveryStateDto state) async {
    return await _collection.doc(id).update({'state': state.toJson()}).toSuccess();
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
    var query = _collection.orderBy('deliveryDate', descending: true).where(_hasEntity(donorId, recipientId));

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

    return query.snapshots().map((snapshot) => snapshot.docs.map((document) => document.data()));
  }

  /// Fetches deliveries with pagination support using cursor-based pagination.
  ///
  /// Use [startAfterDeliveryDate] to fetch deliveries after the last delivery date from the previous page.
  /// Specify [limit] to control page size.
  Future<Iterable<DeliveryDto>> getDeliveriesPage({
    required String donorId,
    required String recipientId,
    required DateTime? startAfterDeliveryDate,
    required int limit,
  }) async {
    var query = _collection.orderBy('deliveryDate', descending: true).where(_hasEntity(donorId, recipientId));

    if (startAfterDeliveryDate != null) {
      query = query.where('deliveryDate', isLessThan: startAfterDeliveryDate);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data());
  }

  /// Adds [meals] to the delivery with given [id]. Then recalculates foodboxes
  /// for the same delivery. Returns a future with true when operation succeeds
  /// and false otherwise.
  Future<bool> addMealsAndBoxes(
    String id,
    Iterable<MealDto> meals,
    Map<String, int> boxes,
  ) async {
    final addMeals = await _collection.doc(id).update({
      'meals': FieldValue.arrayUnion(
        meals.map((e) => e.toJson()).toList(),
      )
    }).toSuccess();

    if (!addMeals) {
      return false;
    }

    // Get the existing delivery and merge the new food box data
    final delivery = await getDeliveryById(id);
    final foodBoxesCount = {for (final e in delivery?.foodBoxes ?? []) e.foodBoxId: e.count};
    for (final box in boxes.entries) {
      foodBoxesCount[box.key] = (foodBoxesCount[box.key] ?? 0) + box.value;
    }

    final foodBoxes = foodBoxesCount.entries.map(
      (e) => FoodBoxDeliveryDto(
        foodBoxId: e.key,
        count: e.value,
      ),
    );

    final updateData = <String, dynamic>{
      'foodBoxes': foodBoxes.map((e) => e.toJson()).toList(),
    };

    // Mark delivery for server-side box transfer (via Cloud Function).
    // Skip if already transferred to avoid resetting it back to false.
    if (delivery?.foodBoxesTransferred != true) {
      updateData['foodBoxesTransferred'] = false;
    }

    return _collection.doc(id).update(updateData).toSuccess();
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

  /// Observes active deliveries (not yet delivered or cancelled) for a given
  /// donor-recipient pair.
  Stream<Iterable<DeliveryDto>> observeActiveDeliveries({
    required String donorId,
    required String recipientId,
  }) {
    final activeStates = [
      DeliveryStateDto.accepted.toJson(),
      DeliveryStateDto.onWayToPickUp.toJson(),
      DeliveryStateDto.inDelivery.toJson(),
    ];

    final query = _collection
        .where(
          Filter.and(
            Filter('state', whereIn: activeStates),
            Filter('donorId', isEqualTo: donorId),
            Filter('recipientId', isEqualTo: recipientId),
          ),
        )
        .where('deliveryDate', isGreaterThanOrEqualTo: DateTimeUtils.lastMidnight());

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()));
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
