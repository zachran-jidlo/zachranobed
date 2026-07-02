import 'package:json_annotation/json_annotation.dart';

/*
 * Command to rebuild the meal_suggestion_dto.g.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'meal_suggestion_dto.g.dart';

@JsonSerializable()
class MealSuggestionDto {
  final String id;
  final String name;
  final List<String> allergens;

  MealSuggestionDto({
    required this.id,
    required this.name,
    required this.allergens,
  });

  factory MealSuggestionDto.fromJson(Map<String, dynamic> json) => _$MealSuggestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealSuggestionDtoToJson(this);
}
