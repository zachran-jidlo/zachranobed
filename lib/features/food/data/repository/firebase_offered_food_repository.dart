import 'package:uuid/uuid.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/dto/meal_detail_dto.dart';
import 'package:zachranobed/common/data/dto/meal_dto.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/meal_service.dart';
import 'package:zachranobed/common/domain/model/delivery.dart';
import 'package:zachranobed/common/domain/model/delivery_page_cursor.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/features/food/data/mapper/offered_food_mapper.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/history_page.dart';
import 'package:zachranobed/features/food/domain/model/offered_food.dart';
import 'package:zachranobed/features/food/domain/repository/offered_food_repository.dart';

/// Implementation of the [OfferedFoodRepository] via Firebase services.
class FirebaseOfferedFoodRepository implements OfferedFoodRepository {
  final DeliveryService _deliveryService;
  final MealService _mealService;

  FirebaseOfferedFoodRepository(
    this._deliveryService,
    this._mealService,
  );

  @override
  Future<HistoryPage> getHistoryPaginated({
    required UserData user,
    required int limit,
    DeliveryPageCursor? startAfter,
  }) async {
    // Deliveries without meals map to no items, so a full page can yield
    // nothing. Keep fetching until we have items or run out, otherwise an
    // empty-but-more page would stall the list.
    final List<OfferedFood> items = [];
    DeliveryPageCursor? cursor = startAfter;

    do {
      final deliveries = await _deliveryService.getDeliveriesPage(
        donorId: user.activePair.donorId,
        recipientId: user.activePair.recipientId,
        startAfter: cursor,
        limit: limit,
      );

      items.addAll(await _mapDeliveriesToOfferedFood(deliveries));

      // Cursor off the last delivery, not the items, so a meal-less delivery
      // still advances. A short page means no more to load.
      final last = deliveries.length == limit ? deliveries.last : null;
      cursor = last != null ? DeliveryPageCursor(deliveryDate: last.deliveryDate, deliveryId: last.id) : null;
    } while (items.isEmpty && cursor != null);

    return HistoryPage(items: items, nextCursor: cursor);
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
    final (mealDetails, meals) = _buildMeals(foodInfo, delivery.donorId);

    if (!await _mealService.addMeals(mealDetails)) {
      return false;
    }

    if (!await _deliveryService.addMealsAndBoxes(delivery.id, meals, boxInfo)) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> addMealsToHistory({
    required UserData user,
    required List<FoodInfo> foodInfo,
  }) async {
    final donorId = user.activePair.donorId;
    final recipientId = user.activePair.recipientId;

    // Distinct doc id so a manual entry never collides with a real same-day
    // delivery. One manual doc per day means repeated adds append to it.
    final id = '$donorId-$recipientId-${DateTimeUtils.getCurrentDayMark()}-manual';

    final existing = await _deliveryService.getDeliveryById(id);
    if (existing == null) {
      final created = await _deliveryService.createDelivery(
        DeliveryDto(
          id: id,
          donorId: donorId,
          recipientId: recipientId,
          deliveryDate: DateTimeUtils.lastMidnight(),
          foodBoxes: [],
          meals: [],
          state: DeliveryStateDto.done,
          type: DeliveryTypeDto.foodDelivery,
          confirmationTime: user.activePair.confirmationTime.inMinutes,
          foodBoxesTransferred: true,
          manualDonation: true,
        ),
      );
      if (!created) {
        return false;
      }
    }

    final (mealDetails, meals) = _buildMeals(foodInfo, donorId);

    if (!await _mealService.addMeals(mealDetails)) {
      return false;
    }

    return _deliveryService.addMeals(id, meals);
  }

  /// Builds the meal detail docs and per-delivery meal entries for [foodInfo].
  (List<MealDetailDto>, List<MealDto>) _buildMeals(
    List<FoodInfo> foodInfo,
    String donorId,
  ) {
    const uuid = Uuid();
    final List<MealDetailDto> mealDetails = [];
    final List<MealDto> meals = [];

    for (final element in foodInfo) {
      final id = uuid.v4();
      mealDetails.add(
        MealDetailDto(
          id: id,
          name: element.dishName ?? "",
          donorId: donorId,
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

    return (mealDetails, meals);
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
