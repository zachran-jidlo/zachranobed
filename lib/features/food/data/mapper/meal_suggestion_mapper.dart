import 'package:zachranobed/features/food/data/dto/meal_suggestion_dto.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';

/// DTO to domain mapper for [MealSuggestion].
extension MealSuggestionMapper on MealSuggestionDto {
  /// Maps DTOs to domain representation.
  MealSuggestion toDomain() {
    return MealSuggestion(
      id: id,
      name: name,
      allergens: allergens,
    );
  }
}

/// DTO to domain mapper for list of [MealSuggestion].
extension MealSuggestionListMapper on List<MealSuggestionDto> {
  /// Maps DTOs to domain representation.
  List<MealSuggestion> toDomain() {
    return map((dto) => dto.toDomain()).toList();
  }
}

/// Domain to DTO mapper for [MealSuggestionDto].
extension MealSuggestionDtoMapper on MealSuggestion {
  /// Maps domain representation to DTOs.
  MealSuggestionDto toDto() {
    return MealSuggestionDto(
      id: id,
      name: name,
      allergens: allergens,
    );
  }
}
