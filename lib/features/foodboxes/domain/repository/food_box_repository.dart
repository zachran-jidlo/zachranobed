import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';

/// Repository to manage food boxes information
abstract class FoodBoxRepository {
  /// Fetches a list of available food box types.
  Future<Iterable<FoodBoxType>> getTypes();

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
}
