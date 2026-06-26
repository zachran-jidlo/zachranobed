import 'package:zachranobed/features/food/domain/repository/meal_suggestion_repository.dart';
import 'package:zachranobed/features/food/domain/usecase/get_meal_suggestion_key_use_case.dart';

class AddMealSuggestionUseCase {
  final MealSuggestionRepository _repository;
  final GetMealSuggestionKeyUseCase _getMealSuggestionKey;

  AddMealSuggestionUseCase(this._repository, this._getMealSuggestionKey);

  /// Adds a meal suggestion for [entityId] unless an identical one (same
  /// normalized name and same allergen set) already exists.
  Future<AddMealSuggestionResult> invoke({
    required String entityId,
    required String name,
    required List<String> allergens,
  }) async {
    final key = _getMealSuggestionKey.invoke(name: name, allergens: allergens);
    final existing = await _repository.getAll(entityId: entityId);
    final isDuplicate = existing.any((s) => _getMealSuggestionKey.invoke(name: s.name, allergens: s.allergens) == key);
    if (isDuplicate) {
      return AddMealSuggestionResult.duplicate;
    }

    final id = await _repository.add(entityId: entityId, name: name, allergens: allergens);
    return id != null ? AddMealSuggestionResult.added : AddMealSuggestionResult.failed;
  }
}

/// Result of trying to add a meal suggestion.
enum AddMealSuggestionResult {
  /// The suggestion was created.
  added,

  /// A suggestion with the same name and allergens already exists.
  duplicate,

  /// Saving the suggestion failed.
  failed,
}
