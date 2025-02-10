import 'package:zachranobed/models/dto/food_boxes_checkup_dto.dart';
import 'package:zachranobed/models/food_boxes_checkup.dart';

/// DTO to domain mapper for [FoodBoxesCheckup].
extension FoodBoxesCheckupMapper on FoodBoxesCheckupDto {
  /// Maps DTO to domain representation.
  FoodBoxesCheckup toDomain() {
    return FoodBoxesCheckup(
      status: _getStatus(status),
      checkAt: checkAt,
      verifiedAt: verifiedAt,
    );
  }

  FoodBoxesCheckupStatus _getStatus(FoodBoxesCheckupStatusDto? status) {
    switch (status) {
      case FoodBoxesCheckupStatusDto.ok:
        return FoodBoxesCheckupStatus.ok;
      case FoodBoxesCheckupStatusDto.delayed:
        return FoodBoxesCheckupStatus.delayed;
      case FoodBoxesCheckupStatusDto.mismatch:
        return FoodBoxesCheckupStatus.mismatch;
      case null:
        return FoodBoxesCheckupStatus.ok;
    }
  }
}

/// DTO to domain mapper for [DeliveryType].
extension FoodBoxesCheckupDtoMapper on FoodBoxesCheckupStatus {
  /// Maps DTOs to domain representation.
  FoodBoxesCheckupStatusDto toDto() {
    switch (this) {
      case FoodBoxesCheckupStatus.ok:
        return FoodBoxesCheckupStatusDto.ok;
      case FoodBoxesCheckupStatus.delayed:
        return FoodBoxesCheckupStatusDto.delayed;
      case FoodBoxesCheckupStatus.mismatch:
        return FoodBoxesCheckupStatusDto.mismatch;
    }
  }
}
