import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/models/dto/food_box_type_dto.dart';

/// DTO to domain mapper for [FoodBoxType].
extension FoodBoxTypeMapper on FoodBoxTypeDto {

  /// Maps DTO to domain representation.
  FoodBoxType toDomain() {
    return FoodBoxType(
      id: id,
      name: name,
      type: type,
    );
  }
}
