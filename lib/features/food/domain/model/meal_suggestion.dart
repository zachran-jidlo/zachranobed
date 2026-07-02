import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the meal_suggestion.freezed.dart file:
 * flutter pub run build_runner build --delete-conflicting-outputs
 */
part 'meal_suggestion.freezed.dart';

@freezed
abstract class MealSuggestion with _$MealSuggestion {
  const factory MealSuggestion({
    required String id,
    required String name,
    required List<String> allergens,
  }) = _MealSuggestion;
}
