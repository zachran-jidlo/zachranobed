import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/delivery_page_cursor.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/history_page.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';

/// Repository to manage offered food.
abstract class OfferedFoodRepository {
  /// Fetches a page of offered food history with pagination support.
  ///
  /// Pass the [HistoryPage.nextCursor] from the previous page as [startAfter] to
  /// load the following page. Pass null for the first page. Specify [limit] to
  /// control page size.
  Future<HistoryPage> getHistoryPaginated({
    required UserData user,
    required int limit,
    DeliveryPageCursor? startAfter,
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

  /// Records [foodInfo] straight into history for the [user]'s active pair,
  /// bypassing the normal delivery process. Reuses today's manual delivery doc
  /// (creating it in a valid history state when missing) so repeated calls on
  /// the same day append to the same record. Returns true on success.
  Future<bool> addMealsToHistory({
    required UserData user,
    required List<FoodInfo> foodInfo,
  });

  /// Returns a stream of offered food items for a specific delivery.
  Stream<Iterable<OfferedFood>> observeMealsForDelivery({
    required String deliveryId,
  });
}
