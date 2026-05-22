import 'package:zachranobed/common/data/dto/food_boxes_checkup_dto.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup.dart';
import 'package:zachranobed/common/domain/model/food_boxes_checkup_reported_count.dart';

/// DTO to domain mapper for [FoodBoxesCheckup].
extension FoodBoxesCheckupMapper on FoodBoxesCheckupDto {
  /// Maps DTO to domain representation.
  FoodBoxesCheckup toDomain() {
    return FoodBoxesCheckup(
      status: _getStatus(status),
      checkAt: checkAt,
      verifiedAt: verifiedAt,
      lastChange: _getLastChange(lastChange),
      reportedCounts: reportedCounts?.map((e) => e.toDomain()).toList(),
    );
  }

  FoodBoxesCheckupLastChange _getLastChange(FoodBoxesCheckupLastChangeDto? dto) {
    switch (dto) {
      case FoodBoxesCheckupLastChangeDto.user:
        return FoodBoxesCheckupLastChange.user;
      case FoodBoxesCheckupLastChangeDto.admin:
      case null:
        return FoodBoxesCheckupLastChange.admin;
    }
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

      // There is no DTO representation of "not-needed" status, it is always inferred from the fact if entity-pair
      // uses returnable food boxes.
      case FoodBoxesCheckupStatus.notNeeded:
        return FoodBoxesCheckupStatusDto.ok;
    }
  }
}

/// DTO to domain mapper for [FoodBoxesCheckupReportedCount].
extension FoodBoxesCheckupReportedCountMapper on FoodBoxesCheckupReportedCountDto {
  /// Maps DTO to domain representation.
  FoodBoxesCheckupReportedCount toDomain() {
    return FoodBoxesCheckupReportedCount(
      foodBoxId: foodBoxId,
      realCount: realCount,
      systemCount: systemCount,
    );
  }
}

/// Domain to DTO mapper for [FoodBoxesCheckupReportedCount].
extension FoodBoxesCheckupReportedCountDtoMapper on FoodBoxesCheckupReportedCount {
  /// Maps domain to DTO representation.
  FoodBoxesCheckupReportedCountDto toDto() {
    return FoodBoxesCheckupReportedCountDto(
      foodBoxId: foodBoxId,
      realCount: realCount,
      systemCount: systemCount,
    );
  }
}
