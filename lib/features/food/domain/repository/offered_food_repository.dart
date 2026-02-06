import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {
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
  /// about donated food. The [boxInfo] map contains box IDs as keys and
  /// the number of boxes as values.
  Future<bool> createOffer({
    required Delivery delivery,
    required List<FoodInfo> foodInfo,
    required Map<String, int> boxInfo,
  });

  /// Returns a stream of offered food items for a specific delivery.
  Stream<Iterable<OfferedFood>> observeMealsForDelivery({
    required String deliveryId,
  });
}
