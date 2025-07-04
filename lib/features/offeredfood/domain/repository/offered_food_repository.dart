import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/user_data.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {
  /// Observes the current delivery for a given [user].
  Stream<Delivery?> observeCurrentDelivery({
    required UserData user,
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
  /// count of saved meals for the specified [timePeriod] and [user].
  Future<int> getSavedMealsCount({
    required UserData user,
    int? timePeriod,
  });

  /// Returns a stream with a list of offered food for the [user].
  Stream<Iterable<OfferedFood>> observeHistory({
    required UserData user,
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
    required List<BoxInfo> boxInfo,
  });
}
