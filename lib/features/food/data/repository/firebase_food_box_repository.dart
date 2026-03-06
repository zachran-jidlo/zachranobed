import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zachranobed/common/data/dto/delivery_dto.dart';
import 'package:zachranobed/common/data/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/common/data/dto/food_box_pair_dto.dart';
import 'package:zachranobed/common/data/dto/food_box_type_dto.dart';
import 'package:zachranobed/common/data/mapper/food_boxes_checkup_mapper.dart';
import 'package:zachranobed/common/data/service/delivery_service.dart';
import 'package:zachranobed/common/data/service/entity_pairs_service.dart';
import 'package:zachranobed/common/data/service/food_box_service.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/utils/date_time_utils.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/features/food/data/mapper/food_box_mapper.dart';
import 'package:zachranobed/features/food/domain/model/food_box_statistics.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';
import 'package:zachranobed/features/food/domain/repository/food_box_repository.dart';

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
  String getDisposableBoxId() {
    return FoodBoxTypeDto.idDisposable;
  }

  @override
  Future<Iterable<FoodBoxType>> getTypes({
    bool includeDisposable = false,
  }) async {
    final types = (await _foodBoxService.getAll()).where((element) {
      return includeDisposable || element.id != FoodBoxTypeDto.idDisposable;
    });
    return types.map((e) => e.toDomain()).sorted((a, b) {
      return _getSortOrder(a).compareTo(_getSortOrder(b));
    });
  }

  @override
  Stream<Iterable<FoodBoxStatistics>> observeStatistics(UserData user) async* {
    // Prefetch types once before stream is started to not fetch them with
    // every change in the stream.
    final typesList = await getTypes();
    final typesMap = {for (final v in typesList) v.id: v};

    final donorId = user.activePair.donorId;
    final recipientId = user.activePair.recipientId;

    final pairStream = _entityPairService.observePair(
      donorId: donorId,
      recipientId: recipientId,
    );

    final activeDeliveriesStream = _deliveryService.observeActiveDeliveries(
      donorId: donorId,
      recipientId: recipientId,
    );

    yield* Rx.combineLatest2(pairStream, activeDeliveriesStream, (pair, activeDeliveries) {
      return (pair, activeDeliveries);
    }).map((combined) {
      final (pair, activeDeliveries) = combined;

      // Accumulate pair counts
      final Map<String, FoodBoxPairDto> boxesCountMap = {};
      for (final foodBox in pair?.foodboxes ?? <FoodBoxPairDto>[]) {
        final acc = boxesCountMap[foodBox.foodBoxId];
        boxesCountMap[foodBox.foodBoxId] = FoodBoxPairDto(
          foodBoxId: foodBox.foodBoxId,
          count: (acc?.count ?? 0) + foodBox.count,
          donorCount: (acc?.donorCount ?? 0) + foodBox.donorCount,
          recipientCount: (acc?.recipientCount ?? 0) + foodBox.recipientCount,
        );
      }

      // Accumulate in-transit counts from active deliveries
      final Map<String, int> onTheWayToCharity = {};
      final Map<String, int> onTheWayToCanteen = {};

      for (final delivery in activeDeliveries) {
        if (delivery.foodBoxes.isEmpty) {
          // Skip deliveries without food boxes
          continue;
        }

        final target = switch (delivery.type) {
          DeliveryTypeDto.foodDelivery => onTheWayToCharity,
          DeliveryTypeDto.boxDelivery => onTheWayToCanteen,
          _ => null,
        };

        if (target == null) {
          // Skip deliveries with invalid type
          continue;
        }

        for (final box in delivery.foodBoxes) {
          target[box.foodBoxId] = (target[box.foodBoxId] ?? 0) + box.count;
        }
      }

      // Map accumulated values to domain instances
      return boxesCountMap.values.mapNotNull((element) {
        final type = typesMap[element.foodBoxId];
        if (type == null) {
          // In case that type is not known, ignore this food box data
          return null;
        }

        return FoodBoxStatistics(
          type: type,
          totalQuantity: element.count,
          quantityAtCanteen: element.donorCount,
          quantityAtCharity: element.recipientCount,
          quantityOnTheWayToCharity: onTheWayToCharity[element.foodBoxId] ?? 0,
          quantityOnTheWayToCanteen: onTheWayToCanteen[element.foodBoxId] ?? 0,
        );
      }).sorted((a, b) {
        return _getSortOrder(a.type).compareTo(_getSortOrder(b.type));
      });
    });
  }

  @override
  Future<bool> createBoxDelivery({
    required UserData user,
    required Map<String, int> boxesQuantity,
  }) async {
    final donorId = user.activePair.donorId;
    final recipientId = user.activePair.recipientId;

    // Prepare delivery ID and check if any exists in Firebase
    final id = '$recipientId-$donorId-${DateTimeUtils.getCurrentDayMark()}';
    final delivery = await _deliveryService.getDeliveryById(id);

    // Create a mutable copy to accumulate existing boxes if delivery exists
    final totalQuantity = Map<String, int>.from(boxesQuantity);
    if (delivery != null) {
      for (final box in delivery.foodBoxes) {
        final value = totalQuantity[box.foodBoxId] ?? 0;
        totalQuantity[box.foodBoxId] = value + box.count;
      }
    }

    final foodBoxes = totalQuantity.entries.map((e) {
      return FoodBoxDeliveryDto(
        foodBoxId: e.key,
        count: e.value,
      );
    });

    // Create a new delivery if it is not yet created in Firebase, otherwise
    // just update the existing delivery
    if (delivery == null) {
      final newDelivery = DeliveryDto(
        id: id,
        donorId: donorId,
        recipientId: recipientId,
        deliveryDate: DateTime.now(),
        foodBoxes: foodBoxes.toList(),
        meals: [],
        state: DeliveryStateDto.accepted,
        type: DeliveryTypeDto.boxDelivery,
        confirmationTime: user.activePair.confirmationTime.inMinutes,
      );
      return _deliveryService.createDelivery(newDelivery);
    } else {
      return _deliveryService.updateDeliveryFoodboxes(id, foodBoxes.toList());
    }
  }

  @override
  Future<bool> delayFoodBoxesCheckup({
    required UserData user,
  }) {
    return _entityPairService.updateFoodBoxesCheckupStatus(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      status: FoodBoxesCheckupStatus.delayed.toDto(),
      target: _getFoodBoxesCheckupTarget(user),
      checkAt: user.getFoodBoxesCheckup(user.activePair).checkAt,
    );
  }

  @override
  Future<bool> reportFoodBoxesMismatch({
    required UserData user,
  }) {
    return _entityPairService.updateFoodBoxesCheckupStatus(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      status: FoodBoxesCheckupStatus.mismatch.toDto(),
      target: _getFoodBoxesCheckupTarget(user),
      checkAt: user.getFoodBoxesCheckup(user.activePair).checkAt,
    );
  }

  @override
  Future<bool> verifyFoodBoxesCheckup({
    required UserData user,
  }) {
    return _entityPairService.verifyFoodBoxesCheckup(
      donorId: user.activePair.donorId,
      recipientId: user.activePair.recipientId,
      target: _getFoodBoxesCheckupTarget(user),
      nextCheckAt: DateTimeUtils.getNextFoodBoxesCheckDateTime(),
    );
  }

  /// Get sort order for the [FoodBoxType].
  /// Reusable box should go first, and IKEA boxes should follow.
  int _getSortOrder(FoodBoxType type) {
    switch (type.id) {
      case FoodBoxTypeDto.idDisposable:
        return 0;
      case FoodBoxTypeDto.idRekrabicka:
        return 1;
      case FoodBoxTypeDto.idIkeaLarge:
        return 2;
      case FoodBoxTypeDto.idIkeaSmall:
        return 3;
      case FoodBoxTypeDto.idOther:
        return 4;
    }
    return 5;
  }

  String _getFoodBoxesCheckupTarget(UserData user) {
    if (user is Canteen) {
      return "donor";
    }
    if (user is Charity) {
      return "recipient";
    }
    throw Exception("Invalid user: $user");
  }
}
