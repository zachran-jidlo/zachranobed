import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/features/offeredfood/data/mapper/delivery_mapper.dart';
import 'package:zachranobed/features/offeredfood/data/mapper/offered_food_mapper.dart';
import 'package:zachranobed/features/offeredfood/domain/model/food_info.dart';
import 'package:zachranobed/features/offeredfood/domain/model/offered_food.dart';
import 'package:zachranobed/features/offeredfood/domain/repository/offered_food_repository.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/meal_detail_dto.dart';
import 'package:zachranobed/models/dto/meal_dto.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/food_box_service.dart';
import 'package:zachranobed/services/meal_service.dart';

/// Implementation of the [OfferedFoodRepository] via Firebase services.
class FirebaseOfferedFoodRepository implements OfferedFoodRepository {
  final List<DeliveryState> closedStates = [
    DeliveryState.inDelivery,
    DeliveryState.delivered,
    DeliveryState.notUsed,
  ];

  final DeliveryService _deliveryService;
  final MealService _mealService;
  final FoodBoxService _foodBoxService;
  final EntityPairService _entityPairService;

  FirebaseOfferedFoodRepository(
    this._deliveryService,
    this._mealService,
    this._foodBoxService,
    this._entityPairService,
  );

  @override
  Stream<Delivery?> observeCurrentDelivery({
    required UserData user,
  }) {
    return _deliveryService
        .observeDelivery(
          donorId: user.activePair.donorId,
          recipientId: user.activePair.recipientId,
        )
        .map((event) => event?.toDomain());
  }

  @override
  bool canDonateFood({required Delivery delivery, required DateTime time}) {
    if (closedStates.contains(delivery.state)) {
      return false;
    }

    final pickupDuration = Duration(minutes: delivery.getConfirmationTime());
    final canDonateUntil = time.subtract(pickupDuration);
    if (delivery.state == DeliveryState.prepared &&
        DateTime.now().isAfter(canDonateUntil)) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> updateDeliveryState({
    required Delivery delivery,
    required DeliveryState state,
  }) {
    return _deliveryService.updateDeliveryState(
      delivery.id,
      state.toDto(),
    );
  }

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
      mealsCount += delivery.meals.fold(0, (inc, e) => inc + e.count);
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
    final boxTypes = await _foodBoxService.getAll();
    final boxTypeMap = {for (final e in boxTypes) e.id: e.name};
    final deliveries = _deliveryService.observeDeliveries(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      limit: limit,
      from: from,
      to: to,
    );

    yield* deliveries.asyncMap((deliveries) async {
      final foodLists = await Future.wait(deliveries.map((delivery) async {
        // Get meal IDs and fetch meal details from MealService
        final mealIds = delivery.meals.map((e) => e.mealId);
        if (mealIds.isEmpty) {
          return const Iterable<OfferedFood>.empty();
        }

        final details = await _mealService.getDetails(mealIds.toList());

        // Map meal with details to the OfferedFood
        return delivery.meals.mapNotNull((meal) {
          final detail = details[meal.mealId];
          if (detail == null) {
            return null;
          }
          final boxType = boxTypeMap[meal.foodBoxId];
          if (boxType == null) {
            return null;
          }
          return detail.toDomain(
            delivery,
            meal,
            boxType,
          );
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

  @override
  Future<bool> createOffer({
    required Delivery delivery,
    required List<FoodInfo> foodInfo,
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

      final boxId = element.foodBoxType?.id ?? "";
      final boxCount = element.numberOfBoxes ?? element.numberOfServings ?? 0;
      meals.add(
        MealDto(
          mealId: id,
          count: element.numberOfServings ?? 0,
          preparedAt: element.preparedAt?.getDate(),
          consumeBy: element.consumeBy?.getDate(),
          foodBoxId: boxId,
          foodBoxCount: boxCount,
          foodTemperature: element.foodTemperature,
        ),
      );

      changeBoxesMap[boxId] = (changeBoxesMap[boxId] ?? 0) + boxCount;
    }

    if (!await _mealService.addMeals(mealDetails)) {
      return false;
    }

    if (!await _deliveryService.addMealsAndBoxes(delivery.id, meals)) {
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

    const state = DeliveryState.offered;
    if (!await updateDeliveryState(delivery: delivery, state: state)) {
      return false;
    }

    return true;
  }
}
