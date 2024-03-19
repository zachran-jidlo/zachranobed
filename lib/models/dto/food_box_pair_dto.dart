import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the food_box_pair_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'food_box_pair_dto.g.dart';

@JsonSerializable()
class FoodBoxPairDto {
  final String foodBoxId;
  final int count;
  final int donorCount;
  final int recipientCount;

  FoodBoxPairDto({
    required this.foodBoxId,
    required this.count,
    required this.donorCount,
    required this.recipientCount,
  });

  factory FoodBoxPairDto.fromJson(Map<String, dynamic> json) =>
      _$FoodBoxPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodBoxPairDtoToJson(this);
}
