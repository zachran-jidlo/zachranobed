import 'package:zachranobed/common/domain/model/box_info.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {
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

  /// Fetches a page of offered food history with pagination support.
  ///
  /// Use [startAfterDate] to fetch items after the last delivery date from the previous page.
  /// Specify [limit] to control page size.
  Future<Iterable<OfferedFood>> getHistoryPaginated({
    required UserData user,
    required int limit,
    DateTime? startAfterDate,
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
