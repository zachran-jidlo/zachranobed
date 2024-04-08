import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the meal_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'meal_dto.g.dart';

@JsonSerializable()
class MealDto {
  final String mealId;
  final int count;

  MealDto({
    required this.mealId,
    required this.count,
  });

  factory MealDto.fromJson(Map<String, dynamic> json) =>
      _$MealDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDtoToJson(this);
}
