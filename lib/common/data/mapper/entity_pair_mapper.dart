import 'package:collection/collection.dart';
import 'package:zachranobed/common/data/dto/entity_dto.dart';
import 'package:zachranobed/common/data/dto/entity_pair_dto.dart';
import 'package:zachranobed/common/data/dto/food_boxes_checkup_dto.dart';
import 'package:zachranobed/common/data/mapper/food_boxes_checkup_mapper.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/local_time.dart';
import 'package:zachranobed/common/domain/utils/iterable_utils.dart';

/// DTO to domain mapper for [EntityPair].
extension EntityPairMapper on EntityPairDto {
  /// Maps DTO to domain representation.
  EntityPair? toDomain({
    EntityDto? donor,
    EntityDto? recipient,
  }) {
    if (donor == null || recipient == null) {
      return null;
    }

    final pickupTimeWindow = pickupTimeWindows.firstOrNull;
    if (pickupTimeWindow == null) {
      return null;
    }

    final pickupTimeStart = fromString(pickupTimeWindow.start);
    final pickupTimeEnd = fromString(pickupTimeWindow.end);
    if (pickupTimeStart == null || pickupTimeEnd == null) {
      return null;
    }

    final deliveryTimeWindow = deliveryTimeWindows.firstOrNull;
    if (deliveryTimeWindow == null) {
      return null;
    }

    final deliveryTimeStart = fromString(deliveryTimeWindow.start);
    final deliveryTimeEnd = fromString(deliveryTimeWindow.end);
    if (deliveryTimeStart == null || deliveryTimeEnd == null) {
      return null;
    }

    final usesReturnableFoodBoxes = foodboxes.any((e) => e.count > 0);

    return EntityPair(
      donorId: donor.id,
      donorEstablishmentName: donor.establishmentName,
      recipientId: recipient.id,
      recipientEstablishmentName: recipient.establishmentName,
      carrierId: carrierId,
      pickupTimeStart: pickupTimeStart,
      pickupTimeEnd: pickupTimeEnd,
      deliveryTimeStart: deliveryTimeStart,
      deliveryTimeEnd: deliveryTimeEnd,
      usesReturnableFoodBoxes: usesReturnableFoodBoxes,
      donorFoodBoxesCheckup: _getCheckup(usesReturnableFoodBoxes, foodboxesCheckup?.donor),
      recipientFoodBoxesCheckup: _getCheckup(usesReturnableFoodBoxes, foodboxesCheckup?.recipient),
      confirmationTime: Duration(minutes: confirmationTime),
    );
  }

  /// Maps the food boxes checkup DTO to domain model.
  ///
  /// The checkup state is determined as follows:
  /// 1. If the pair doesn't use returnable food boxes → checkup is not needed,
  ///    the regular checkup flow will be skipped entirely.
  /// 2. If no checkup DTO exists (first-time setup) → defaults to OK status with no
  ///    verification, allowing normal app usage.
  /// 3. Otherwise → maps the DTO to domain, preserving the actual checkup state
  ///    from the backend (ok, delayed, mismatch).
  FoodBoxesCheckup _getCheckup(bool usesReturnableFoodBoxes, FoodBoxesCheckupDto? dto) {
    if (!usesReturnableFoodBoxes) {
      return FoodBoxesCheckup(
        status: FoodBoxesCheckupStatus.notNeeded,
        checkAt: DateTime.now(),
        verifiedAt: null,
        lastChange: FoodBoxesCheckupLastChange.admin,
      );
    }

    if (dto == null) {
      return FoodBoxesCheckup(
        status: FoodBoxesCheckupStatus.ok,
        checkAt: DateTime.now(),
        verifiedAt: null,
        lastChange: FoodBoxesCheckupLastChange.admin,
      );
    }

    return dto.toDomain();
  }

  LocalTime? fromString(String time) {
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$');
    final match = regex.firstMatch(time);

    if (match == null) {
      return null;
    }

    final hour = match.group(1);
    final minute = match.group(2);
    if (hour == null || minute == null) {
      return null;
    }

    return LocalTime(
      hour: int.parse(hour),
      minute: int.parse(minute),
    );
  }
}

/// DTO to domain mapper for list of [EntityPair].
extension EntityPairListMapper on List<EntityPairDto> {
  /// Maps DTO to domain representation.
  ///
  /// This method retrieves the entity details for the donor and recipient of
  /// each pair using the provided [entities] function. The resulting list is
  /// sorted based on the establishment name of the other entity in the pair
  /// (recipient for donor, donor for recipient).
  Future<List<EntityPair>> toDomain({
    required String userEntityId,
    required Future<List<EntityDto>> Function(List<String> ids) entities,
  }) async {
    final targetIds = mapNotNull((e) {
      if (userEntityId == e.donorId) {
        return e.recipientId;
      }
      if (userEntityId == e.recipientId) {
        return e.donorId;
      }
      return null;
    });

    final entitiesList = await entities([userEntityId, ...targetIds]);
    final entitiesMap = {for (final e in entitiesList) e.id: e};
    final pairs = mapNotNull(
      (pair) => pair.toDomain(
        donor: entitiesMap[pair.donorId],
        recipient: entitiesMap[pair.recipientId],
      ),
    );

    return pairs.toList().sortedBy((e) {
      if (userEntityId == e.donorId) {
        return e.recipientEstablishmentName;
      }
      if (userEntityId == e.recipientId) {
        return e.donorEstablishmentName;
      }
      return "";
    });
  }
}
