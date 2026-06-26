import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestion_key_use_case.dart';

class SaveMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;
  final GetMealSuggestionKeyUseCase _getMealSuggestionKey;

  SaveMealSuggestionsUseCase(this._repository, this._getMealSuggestionKey);

  /// Saves any meal in [foodInfo] that is not already a suggestion for
  /// [entityId]. Duplicates (same normalized name and same allergen set) are
  /// skipped, while the same name with different allergens is kept as a separate
  /// suggestion. Best-effort: never throws, so it cannot break the donation flow.
  Future<void> invoke({
    required String entityId,
    required List<FoodInfo> foodInfo,
  }) async {
    try {
      final existing = await _repository.getAll(entityId: entityId);
      final seen = existing
          .map((s) => _getMealSuggestionKey.invoke(name: s.name, allergens: s.allergens))
          .toSet();

      final writes = <Future<bool>>[];
      for (final food in foodInfo) {
        final name = food.dishName?.trim() ?? '';
        final allergens = food.allergens ?? const [];
        if (name.isEmpty || allergens.isEmpty) {
          continue;
        }

        // Returns false when the key is already present, so this de-dups against
        // existing suggestions and earlier items in the same batch at once.
        if (!seen.add(_getMealSuggestionKey.invoke(name: name, allergens: allergens))) {
          continue;
        }

        writes.add(_repository.add(entityId: entityId, name: name, allergens: allergens));
      }

      // The writes are independent, so run them concurrently instead of
      // serializing a round-trip per food item
      await Future.wait(writes);
    } catch (_) {
      // Suggestions must never break the donation flow.
    }
  }
}
