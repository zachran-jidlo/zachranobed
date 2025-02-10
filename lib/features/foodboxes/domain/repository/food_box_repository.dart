import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/models/user_data.dart';

/// Repository to manage food boxes information
abstract class FoodBoxRepository {
  /// Fetches a list of available food box types.
  /// Use [includeDisposable] flag to control whether disposable box type
  /// should be returned.
  Future<Iterable<FoodBoxType>> getTypes({bool includeDisposable = false});

  /// Return a stream with a list of food box statistics for the [user].
  Stream<Iterable<FoodBoxStatistics>> observeStatistics(UserData user);

  /// Returns a stream with a list of box movements for the [user].
  Stream<Iterable<BoxMovement>> observeHistory({
    required UserData user,
    required DateTime from,
    required DateTime to,
  });

  /// Checks if entity with the given [user] has at least [requiredBoxes]
  /// count. The [requiredBoxes] map contains keys with box IDs and values for
  /// count of required boxes. The [getQuantity] lambda is used to get correct
  /// quantity from [FoodBoxStatistics] instance for comparison.
  Future<bool> verifyAvailableBoxCount({
    required UserData user,
    required Map<String, int> requiredBoxes,
    required int Function(FoodBoxStatistics) getQuantity,
  });

  /// Creates a box delivery from the given [user] to it's active pair.
  Future<bool> createBoxDelivery({
    required UserData user,
    required List<BoxInfo> boxInfo,
  });

  /// Returns a count of food boxes movements of the given [user].
  Future<int> getMovementBoxesCount({
    required UserData user,
  });

  /// Delays a food boxes checkup for the given [user].
  Future<bool> delayFoodBoxesCheckup({
    required UserData user,
  });

  /// Reports a mismatch in a food boxes checkup for the given [user].
  Future<bool> reportFoodBoxesMismatch({
    required UserData user,
  });

  /// Verifies a food boxes checkup for the given [user].
  Future<bool> verifyFoodBoxesCheckup({
    required UserData user,
  });
}
