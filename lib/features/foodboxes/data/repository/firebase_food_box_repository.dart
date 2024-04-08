import 'package:collection/collection.dart';
import 'package:zachranobed/common/utils/date_time_utils.dart';
import 'package:zachranobed/common/utils/iterable_utils.dart';
import 'package:zachranobed/features/foodboxes/data/mapper/food_box_mapper.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_info.dart';
import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/features/foodboxes/domain/repository/food_box_repository.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/models/dto/food_box_pair_dto.dart';
import 'package:zachranobed/models/dto/food_box_type_dto.dart';
import 'package:zachranobed/services/delivery_service.dart';
import 'package:zachranobed/services/entity_pairs_service.dart';
import 'package:zachranobed/services/food_box_service.dart';

/// Implementation of the [FoodBoxRepository] via Firebase services.
class FirebaseFoodBoxRepository implements FoodBoxRepository {
  final FoodBoxService _foodBoxService;
  final EntityPairService _entityPairService;
  final DeliveryService _deliveryService;

  FirebaseFoodBoxRepository(
    this._foodBoxService,
    this._entityPairService,
    this._deliveryService,
  );

  @override
  Future<Iterable<FoodBoxType>> getTypes({
    bool includeDisposable = false,
  }) async {
    final types = (await _foodBoxService.getAll()).where((element) {
      return includeDisposable || element.id != FoodBoxTypeDto.idDisposable;
    });
    return types.map((e) => e.toDomain());
  }

  @override
  Stream<Iterable<FoodBoxStatistics>> observeStatistics(
      String entityId) async* {
    // Prefetch types once before stream is started to not fetch them with
    // every change in the stream.
    final typesList = await getTypes();
    final typesMap = {for (final v in typesList) v.id: v};

    yield* _entityPairService.observePairs(entityId).map((pairs) {
      // Create accumulator map, as multiple pairs may have same food box types
      // and we would like to show aggregated statistics across all pairs.
      final Map<String, FoodBoxPairDto> boxesCountMap = {};

      for (final pair in pairs) {
        for (final foodBox in pair.foodboxes) {
          final acc = boxesCountMap[foodBox.foodBoxId];
          boxesCountMap[foodBox.foodBoxId] = FoodBoxPairDto(
            foodBoxId: foodBox.foodBoxId,
            count: (acc?.count ?? 0) + foodBox.count,
            donorCount: (acc?.donorCount ?? 0) + foodBox.donorCount,
            recipientCount: (acc?.recipientCount ?? 0) + foodBox.recipientCount,
          );
        }
      }

      // Map accumulated values to domain instances
      return boxesCountMap.values.mapNotNull((element) {
        // In case that type is not known, ignore this food box data
        final type = typesMap[element.foodBoxId];
        if (type == null) {
          return null;
        }
        return FoodBoxStatistics(
          type: type,
          totalQuantity: element.count,
          quantityAtCanteen: element.donorCount,
          quantityAtCharity: element.recipientCount,
        );
      }).sorted((a, b) {
        return _getSortOrder(a.type).compareTo(_getSortOrder(b.type));
      });
    });
  }

  @override
  Stream<Iterable<BoxMovement>> observeHistory({
    required String entityId,
    required DateTime from,
    required DateTime to,
  }) async* {
    // Prefetch types once before stream is started to not fetch them with
    // every change in the stream.
    final typesList = await getTypes();
    final typesMap = {for (final v in typesList) v.id: v};

    yield* _deliveryService
        .observeDeliveries(entityId, null, from, to)
        .map((deliveries) {
      final foodLists = deliveries.map((delivery) {
        // Map food-boxes with types to the BoxMovement
        return delivery.foodBoxes.mapNotNull((element) {
          final type = typesMap[element.foodBoxId];
          if (type == null) {
            return null;
          }
          return element.toDomain(
            delivery: delivery,
            type: type,
            isNegative: _shouldUseNegativeBoxCount(entityId, delivery),
          );
        });
      });
      // Flatten a list of lists in single list
      return foodLists.expand((element) => element);
    });
  }

  @override
  Future<bool> verifyAvailableBoxCount({
    required String entityId,
    required Map<String, int> requiredBoxes,
    required int Function(FoodBoxStatistics) getQuantity,
  }) async {
    final statistics = await observeStatistics(entityId).first;
    final statisticsMap = {for (final s in statistics) s.type.id: s};

    for (final item in requiredBoxes.entries) {
      final required = item.value;

      var available = 0;
      final statisticsItem = statisticsMap[item.key];
      if (statisticsItem != null) {
        available = getQuantity(statisticsItem);
      }

      if (available < required && item.key != FoodBoxTypeDto.idDisposable) {
        return false;
      }
    }

    return true;
  }

  @override
  Future<bool> createBoxDelivery({
    required String entityId,
    required String donorId,
    required List<BoxInfo> boxInfo,
  }) async {
    final foodBoxesCount = <String, int>{};
    for (final info in boxInfo) {
      final foodBoxId = info.foodBoxId;
      if (foodBoxId == null) {
        continue;
      }
      final required = info.numberOfBoxes ?? 0;
      foodBoxesCount[foodBoxId] = (foodBoxesCount[foodBoxId] ?? 0) + required;
    }

    final foodBoxes = foodBoxesCount.entries.map((e) {
      return FoodBoxDeliveryDto(
        foodBoxId: e.key,
        count: e.value,
      );
    });

    final id = '$donorId-$entityId-${DateTimeUtils.getCurrentDayMark()}';
    final dto = DeliveryDto(
      id: id,
      donorId: donorId,
      recipientId: entityId,
      deliveryDate: DateTime.now(),
      foodBoxes: foodBoxes.toList(),
      meals: [],
      state: DeliveryStateDto.offered,
      type: DeliveryTypeDto.boxDelivery,
    );

    return _deliveryService.createDelivery(dto);
  }

  @override
  Future<int> getMovementBoxesCount({required String entityId}) async {
    final deliveries = await _deliveryService
        .observeDeliveries(entityId, null, null, null)
        .first;

    return deliveries.fold<int>(0, (totalCount, delivery) {
      final count = delivery.foodBoxes.fold(0, (acc, foodBox) => foodBox.count);
      return totalCount + count;
    });
  }

  /// Get sort order for the [FoodBoxType].
  /// Reusable box should go first, and IKEA boxes should follow.
  int _getSortOrder(FoodBoxType type) {
    switch (type.id) {
      case FoodBoxTypeDto.idRekrabicka:
        return 0;
      case FoodBoxTypeDto.idIkeaLarge:
        return 1;
      case FoodBoxTypeDto.idIkeaSmall:
        return 2;
      case FoodBoxTypeDto.idDisposable:
        return 3;
    }
    return 4;
  }

  /// The box count is always a positive integer, thus in some cases we need
  /// to "flip a sign" to display a direction (get vs. send).
  bool _shouldUseNegativeBoxCount(String entityId, DeliveryDto delivery) {
    // We need to flip a sign when current user is a charity and delivery type
    // is "sending boxes".
    if (delivery.type == DeliveryTypeDto.boxDelivery &&
        entityId == delivery.recipientId) {
      return true;
    }

    // Also we need to flip a sign when current user is a canteen and delivery
    // type is "sending food".
    if (delivery.type == DeliveryTypeDto.foodDelivery &&
        entityId == delivery.donorId) {
      return true;
    }

    return false;
  }
}
