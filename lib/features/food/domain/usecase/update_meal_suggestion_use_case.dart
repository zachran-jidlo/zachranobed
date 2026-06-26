import 'package:zachranobed/features/food/domain/model/meal_suggestion.dart';
import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestion_key_use_case.dart';

class UpdateMealSuggestionUseCase {
  final MealSuggestionRepository _repository;
  final GetMealSuggestionKeyUseCase _getMealSuggestionKey;

  UpdateMealSuggestionUseCase(this._repository, this._getMealSuggestionKey);

  /// Updates the given [suggestion] for [entityId] unless another suggestion (a
  /// different id) with the same normalized name and allergen set already exists.
  Future<UpdateMealSuggestionResult> invoke({
    required String entityId,
    required MealSuggestion suggestion,
  }) async {
    final key = _getMealSuggestionKey.invoke(name: suggestion.name, allergens: suggestion.allergens);
    final existing = await _repository.getAll(entityId: entityId);
    final isDuplicate = existing.any(
      (s) => s.id != suggestion.id && _getMealSuggestionKey.invoke(name: s.name, allergens: s.allergens) == key,
    );
    if (isDuplicate) {
      return UpdateMealSuggestionResult.duplicate;
    }

    final success = await _repository.update(entityId: entityId, suggestion: suggestion);
    return success ? UpdateMealSuggestionResult.updated : UpdateMealSuggestionResult.failed;
  }
}

/// Result of trying to update a meal suggestion.
enum UpdateMealSuggestionResult {
  /// The suggestion was updated.
  updated,

  /// Another suggestion with the same name and allergens already exists.
  duplicate,

  /// Updating the suggestion failed.
  failed,
}
