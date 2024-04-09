import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/models/delivery.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {
  /// Returns a [Future] that completes with a [Delivery] object if a delivery
  /// with the provided [time] and [entityId] as a donor ID is found in the
  /// Firestore collection and `null` if no delivery is found with the specified
  /// criteria.
  Future<Delivery?> getCurrentDelivery({
    required String entityId,
    required DateTime time,
  });

  /// Checks if canteen could donate to the given [delivery]. The [time]
  /// parameter contains the start of the canteen's pickup window.
  bool canDonateFood({
    required Delivery delivery,
    required DateTime time,
  });

  /// Updates the state of a [delivery] with the provided [state].
  Future<void> updateDeliveryState({
    required Delivery delivery,
    required DeliveryState state,
  });

  /// Returns a [Future] that completes with an [int] representing the total
  /// count of saved meals for the specified [timePeriod] and user with given
  /// [entityId].
  Future<int> getSavedMealsCount({
    required String entityId,
    int? timePeriod,
  });

  /// Returns a stream with a list of offered food for the user with given
  /// [entityId].
  Stream<Iterable<OfferedFood>> observeHistory({
    required String entityId,
    int? limit,
    DateTime? from,
    DateTime? to,
  });

  /// Creates a food offer to the given [delivery] and updates a [delivery]
  /// with a correct state. The [foodInfo] contains all necessary information
  /// about donated food.
  Future<bool> createOffer({
    required Delivery delivery,
    required List<FoodInfo> foodInfo,
  });
}