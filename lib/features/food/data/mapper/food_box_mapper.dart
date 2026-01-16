import 'package:zachranobed/common/data/dto/food_box_type_dto.dart';
import 'package:zachranobed/features/food/domain/model/food_box_type.dart';

/// DTO to domain mapper for [FoodBoxType].
extension FoodBoxTypeMapper on FoodBoxTypeDto {
  /// Maps DTO to domain representation.
  FoodBoxType toDomain() {
    return FoodBoxType(
      id: id,
      name: name,
    );
  }
}
