import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/dto/meal_detail_dto.dart';
import 'package:zachranobed/common/data/dto/meal_dto.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/common/domain/model/box_info.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/delivery_repository.dart';
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
  final DeliveryRepository _deliveryRepository;

  FirebaseOfferedFoodRepository(
    this._deliveryService,
    this._mealService,
    this._entityPairService,
    this._deliveryRepository,
  );

  @override
  Future<int> getSavedMealsCount({
    required UserData user,
    int? timePeriod,
  }) async {
    var mealsCount = 0;
    final deliveries = await _deliveryService.getDeliveries(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      timePeriod: timePeriod,
    );
    for (var delivery in deliveries) {
      // Count all meals in all deliveries except packaged meals
      mealsCount += delivery.meals.fold(0, (inc, e) => inc + (e.count ?? 0));
    }
    return mealsCount;
  }

  @override
  Stream<Iterable<OfferedFood>> observeHistory({
    required UserData user,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) async* {
    final deliveries = _deliveryService.observeDeliveries(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      limit: limit,
      from: from,
      to: to,
    );

    yield* deliveries.asyncMap((deliveries) async {
      return _mapDeliveriesToOfferedFood(deliveries);
    });
  }

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
    required List<BoxInfo> boxInfo,
  }) async {
    const uuid = Uuid();
    final List<MealDetailDto> mealDetails = [];
    final List<MealDto> meals = [];
    final Map<String, int> changeBoxesMap = {};
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

    for (final element in boxInfo) {
      final boxId = element.foodBoxId;
      final boxCount = element.numberOfBoxes;
      if (boxId != null && boxCount != null) {
        changeBoxesMap[boxId] = (changeBoxesMap[boxId] ?? 0) + boxCount;
      }
    }

    if (!await _mealService.addMeals(mealDetails)) {
      return false;
    }

    if (!await _deliveryService.addMealsAndBoxes(delivery.id, meals, changeBoxesMap)) {
      return false;
    }

    final moveBoxesSuccess = await _entityPairService.moveBoxesToRecipient(
      donorId: delivery.donorId,
      recipientId: delivery.recipientId,
      changeMap: changeBoxesMap,
    );

    if (!moveBoxesSuccess) {
      return false;
    }

    final updateStateSuccess = await _deliveryRepository.updateDeliveryState(
      delivery: delivery,
      state: DeliveryState.offered,
    );
    if (!updateStateSuccess) {
      return false;
    }

    return true;
  }
}
