import 'package:collection/collection.dart';
import 'package:zachranobed/common/data/dto/entity_dto.dart';
import 'package:zachranobed/common/data/dto/entity_pair_dto.dart';
import 'package:zachranobed/common/data/dto/food_boxes_checkup_dto.dart';
import 'package:zachranobed/common/data/mapper/food_boxes_checkup_mapper.dart';
import 'package:zachranobed/common/domain/model/entity_pair.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
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

    final window = pickupTimeWindows.firstOrNull;
    if (window == null) {
      return null;
    }

    return EntityPair(
      donorId: donor.id,
      donorEstablishmentName: donor.establishmentName,
      recipientId: recipient.id,
      recipientEstablishmentName: recipient.establishmentName,
      carrierId: carrierId,
      pickupTimeStart: window.start,
      pickupTimeEnd: window.end,
      donorFoodBoxesCheckup: _getCheckup(foodboxesCheckup?.donor),
      recipientFoodBoxesCheckup: _getCheckup(foodboxesCheckup?.recipient),
      confirmationTime: confirmationTime,
    );
  }

  FoodBoxesCheckup _getCheckup(FoodBoxesCheckupDto? dto) {
    return dto?.toDomain() ?? FoodBoxesCheckup.createDefault();
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
