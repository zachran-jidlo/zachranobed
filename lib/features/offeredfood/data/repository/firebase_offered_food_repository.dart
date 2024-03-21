import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/features/offeredfood/data/mapper/offered_food_mapper.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/meal_service.dart';

/// Implementation of the [OfferedFoodRepository] via Firebase services.
class FirebaseOfferedFoodRepository implements OfferedFoodRepository {
  final DeliveryService _deliveryService;
  final MealService _mealService;

  FirebaseOfferedFoodRepository(this._deliveryService, this._mealService);

  @override
  Future<int> getSavedMealsCount({
    required String entityId,
    int? timePeriod,
  }) async {
    var mealsCount = 0;
    final deliveries =
        await _deliveryService.getDeliveries(entityId, timePeriod);
    for (var delivery in deliveries) {
      mealsCount += delivery.meals.fold(0, (inc, e) => inc + e.count);
    }
    return mealsCount;
  }

  @override
  Stream<Iterable<OfferedFood>> observeHistory({
    required String entityId,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) {
    return _deliveryService
        .observeDeliveries(entityId, limit, from, to)
        .asyncMap((deliveries) async {
      final foodLists = await Future.wait(deliveries.map((delivery) async {
        // Get meal IDs and fetch meal details from MealService
        final mealIds = delivery.meals.map((e) => e.mealId);
        final details = await _mealService.getDetails(mealIds.toList());

        // Map meal with details to the OfferedFood
        return delivery.meals.mapNotNull((meal) {
          final detail = details[meal.mealId];
          if (detail == null) {
            return null;
          }
          return detail.toDomain(delivery, meal);
        });
      }));
      // Flatten a list of lists in single list
      var food = foodLists.expand((element) => element);
      if (limit != null) {
        // As a delivery may have multiple meals, the "food" list may contain
        // more items than requested, thus we should limit also after flattening
        food = food.take(limit);
      }
      return food;
    });
  }
}
