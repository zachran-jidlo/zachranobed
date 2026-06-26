import 'package:collection/collection.dart';
import 'package:zachranobed/common/domain/utils/string_utils.dart';
import 'package:zachranobed/features/food/domain/model/food_info.dart';
import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';

class SaveMealSuggestionsUseCase {
  final MealSuggestionRepository _repository;

  SaveMealSuggestionsUseCase(this._repository);

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
      final seen = existing.map(_key).toSet();

      for (final food in foodInfo) {
        final name = food.dishName?.trim() ?? '';
        final allergens = food.allergens ?? const [];
        if (name.isEmpty || allergens.isEmpty) {
          continue;
        }

        // Returns false when the key is already present, so this de-dups against
        // existing suggestions and earlier items in the same batch at once.
        if (!seen.add(_keyOf(name, allergens))) {
          continue;
        }

        await _repository.add(entityId: entityId, name: name, allergens: allergens);
      }
    } catch (_) {
      // Suggestions must never break the donation flow.
    }
  }

  String _key(MealSuggestion suggestion) => _keyOf(suggestion.name, suggestion.allergens);

  /// Builds a dedup key from a normalized name and an order-independent allergen set.
  String _keyOf(String name, List<String> allergens) {
    return '${name.searchNormalized}|${allergens.sorted().join(',')}';
  }
}
