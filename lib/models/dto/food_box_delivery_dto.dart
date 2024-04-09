import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the food_box_delivery_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_box_delivery_dto.g.dart';

@JsonSerializable()
class FoodBoxDeliveryDto {
  final String foodBoxId;
  final int count;

  FoodBoxDeliveryDto({
    required this.foodBoxId,
    required this.count,
  });

  factory FoodBoxDeliveryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodBoxDeliveryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxDeliveryDtoToJson(this);
}
