import 'package:zachranobed/features/foodboxes/domain/model/box_movement.dart';
import 'package:zachranobed/features/foodboxes/domain/model/food_box_type.dart';
import 'package:zachranobed/models/dto/delivery_dto.dart';
import 'package:zachranobed/models/dto/food_box_delivery_dto.dart';
import 'package:zachranobed/models/dto/food_box_type_dto.dart';

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

/// DTO to domain mapper for [BoxMovement].
extension BoxMovementMapper on FoodBoxDeliveryDto {
  /// Maps DTO to domain representation.
  BoxMovement toDomain({
    required DeliveryDto delivery,
    required FoodBoxType type,
    required bool isNegative,
  }) {
    return BoxMovement(
      type: type,
      count: isNegative ? -count : count,
      date: delivery.deliveryDate,
    );
  }
}
