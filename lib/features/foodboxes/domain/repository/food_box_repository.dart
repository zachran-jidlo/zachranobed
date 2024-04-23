import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';

/// Repository to manage food boxes information
abstract class FoodBoxRepository {
  /// Fetches a list of available food box types.
  /// Use [includeDisposable] flag to control whether disposable box type
  /// should be returned.
  Future<Iterable<FoodBoxType>> getTypes({bool includeDisposable = false});

  /// Return a stream with a list of food box statistics for the user with
  /// given [entityId].
  Stream<Iterable<FoodBoxStatistics>> observeStatistics(String entityId);

  /// Returns a stream with a list of box movements for the user with given
  /// [entityId].
  Stream<Iterable<BoxMovement>> observeHistory({
    required String entityId,
    required DateTime from,
    required DateTime to,
  });

  /// Checks if entity with the given [entityId] has at least [requiredBoxes]
  /// count. The [requiredBoxes] map contains keys with box IDs and values for
  /// count of required boxes. The [getQuantity] lambda is used to get correct
  /// quantity from [FoodBoxStatistics] instance for comparison.
  Future<bool> verifyAvailableBoxCount({
    required String entityId,
    required Map<String, int> requiredBoxes,
    required int Function(FoodBoxStatistics) getQuantity,
  });

  /// Creates a box delivery from the given [entityId] to the [donorId] with
  /// a given list of boxes using the [carrierId].
  Future<bool> createBoxDelivery({
    required String entityId,
    required String donorId,
    required String carrierId,
    required List<BoxInfo> boxInfo,
  });

  Future<int> getMovementBoxesCount({
    required String entityId,
  });
}
