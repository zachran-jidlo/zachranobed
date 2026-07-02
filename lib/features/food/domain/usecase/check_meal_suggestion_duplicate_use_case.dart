import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestion_key_use_case.dart';

class CheckMealSuggestionDuplicateUseCase {
  final GetMealSuggestionKeyUseCase _getMealSuggestionKey;

  CheckMealSuggestionDuplicateUseCase(this._getMealSuggestionKey);

  /// Returns true when [existing] already contains a suggestion with the same
  /// normalized name and allergen set as the given [name] and [allergens].
  ///
  /// The suggestion with [excludeId] is ignored, so editing a suggestion does
  /// not count as a duplicate of itself.
  bool invoke({
    required List<MealSuggestion> existing,
    required String name,
    required List<String> allergens,
    String? excludeId,
  }) {
    final key = _getMealSuggestionKey.invoke(name: name, allergens: allergens);
    return existing.any(
      (item) {
        final itemKey = _getMealSuggestionKey.invoke(name: item.name, allergens: item.allergens);
        return item.id != excludeId && itemKey == key;
      },
    );
  }
}
