import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/dto/meal_detail_dto.dart';
import 'package:zachranobed/common/data/dto/meal_dto.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/features/food/data/mapper/offered_food_mapper.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// Implementation of the [OfferedFoodRepository] via Firebase services.
class FirebaseOfferedFoodRepository implements OfferedFoodRepository {
  final DeliveryService _deliveryService;
  final MealService _mealService;
  final EntityPairService _entityPairService;

  FirebaseOfferedFoodRepository(
    this._deliveryService,
    this._mealService,
    this._entityPairService,
  );

  @override
  Future<Iterable<OfferedFood>> getHistoryPaginated({
    required UserData user,
    required int limit,
    DateTime? startAfterDate,
  }) async {
    final deliveries = await _deliveryService.getDeliveriesPage(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      startAfterDeliveryDate: startAfterDate,
      limit: limit,
    );

    return _mapDeliveriesToOfferedFood(deliveries);
  }

  Future<Iterable<OfferedFood>> _mapDeliveriesToOfferedFood(
    Iterable<DeliveryDto> deliveries,
  ) async {
    final foodLists = await Future.wait(deliveries.map((delivery) async {
      // Get meal IDs and fetch meal details from MealService
      final mealIds = delivery.meals.map((e) => e.mealId);
      if (mealIds.isEmpty) {
        return const Iterable<OfferedFood>.empty();
      }

      final details = await _mealService.getDetails(mealIds.toList());

      // Map meal with details to the OfferedFood
      return delivery.meals.mapNotNull<OfferedFood>((meal) {
        final detail = details[meal.mealId];
        if (detail == null) {
          return null;
        }
        return detail.toDomain(delivery, meal);
      });
    }));

    // Flatten a list of lists in single list
    return foodLists.expand((element) => element);
  }

  @override
  Future<bool> createOffer({
    required Delivery delivery,
    required List<FoodInfo> foodInfo,
    required Map<String, int> boxInfo,
  }) async {
    const uuid = Uuid();
    final List<MealDetailDto> mealDetails = [];
    final List<MealDto> meals = [];

    for (final element in foodInfo) {
      final id = uuid.v4();
      mealDetails.add(
        MealDetailDto(
          id: id,
          name: element.dishName ?? "",
          donorId: delivery.donorId,
          foodCategory: element.foodCategory?.name ?? "",
          foodCategoryType: element.foodCategory?.type.name ?? "",
          allergens: element.allergens ?? [],
        ),
      );

      meals.add(
        MealDto(
          mealId: id,
          count: element.numberOfServings,
          packagesCount: element.numberOfPackages,
          preparedAt: element.preparedAt?.getDate(),
          consumeBy: element.consumeBy?.getDate(),
          foodTemperature: element.foodTemperature,
        ),
      );
    }

    if (!await _mealService.addMeals(mealDetails)) {
      return false;
    }

    if (!await _deliveryService.addMealsAndBoxes(delivery.id, meals, boxInfo)) {
      return false;
    }

    final moveBoxesSuccess = await _entityPairService.moveBoxesToRecipient(
      donorId: delivery.donorId,
      recipientId: delivery.recipientId,
      changeMap: boxInfo,
    );

    if (!moveBoxesSuccess) {
      return false;
    }

    return true;
  }

  @override
  Stream<Iterable<OfferedFood>> observeMealsForDelivery({
    required String deliveryId,
  }) async* {
    final deliveryStream = _deliveryService.observeDeliveryById(deliveryId);

    yield* deliveryStream.asyncMap((delivery) async {
      if (delivery == null) {
        return const Iterable<OfferedFood>.empty();
      }
      return _mapDeliveriesToOfferedFood([delivery]);
    });
  }
}
