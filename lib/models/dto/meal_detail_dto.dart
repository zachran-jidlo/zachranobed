import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the meal_detail_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'meal_detail_dto.g.dart';

@JsonSerializable()
class MealDetailDto {
  final String id;
  final String name;
  final String donorId;
  final String foodCategory;
  final String? foodCategoryType;
  final List<String> allergens;

  MealDetailDto({
    required this.id,
    required this.name,
    required this.donorId,
    required this.foodCategory,
    required this.foodCategoryType,
    required this.allergens,
  });

  factory MealDetailDto.fromJson(Map<String, dynamic> json) =>
      _$MealDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDetailDtoToJson(this);
}
