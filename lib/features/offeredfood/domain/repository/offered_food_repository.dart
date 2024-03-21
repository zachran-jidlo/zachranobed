import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {

  /// Returns a [Future] that completes with an [int] representing the total
  /// count of saved meals for the specified [timePeriod] and user with given
  // [entityId].
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
}
